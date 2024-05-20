```shell
npm i && ng serve
```





## Angular Material M3 runtime colors

Everybody who has worked with Angular Material versions 14 or below has probably noticed how complicated it can be to style the components provided by the framework. There is an entire guide in the documentation for defining custom CSS rules that directly style Angular Material components. One of the major problems not explicitly mentioned in the guide, but seen over time, is the high level of _specificity_ and _selectors_ used by the framework by default. Bypassing encapsulation of deeply nested CSS classes often ends up being a mix of `::ng-deep`, `!important`, and a bit of `luck` to achieve a simple modification without breaking everything.


Fortunately, accordingly to the docs 

> [!NOTE]
> [Migrating to MDC-based Angular Material Components](https://material.angular.io/guide/mdc-migration)
> 
> In Angular Material v15 and later, many of the components have been refactored to be based on the official [Material Design Components for Web (MDC)](https://github.com/material-components/material-components-web)

Since I believe most of the production applications in the wild aren't using the latest Angular versions, and considering that Material 3 theming is still experimental and supported by Angular Material 17.2 features, the benefits may go unnoticed by the community. One of the benefits, which is the focus of this article, is the ability to add runtime Angular Material theming colors.

##### Creating a new angular app
Run the command `ng n runtime-angular-material` and chose `scss` as your default stylesheet and no SSR.
```sh
Which stylesheet format would you like to use? 
❯ SCSS [ https://sass-lang.com/documentation/syntax#scss  

Do you want to enable Server-Side Rendering (SSR) ?
❯ No
```

 Lets add Angular Material by running the command `ng add @angular/material`  
 
```sh
✔ Packages successfully installed.

Choose a prebuilt theme name, or "custom" for a custom theme:
❯ Custom

Set up global Angular Material typography styles?
❯ Yes

Include the Angular animations module? 
❯ Include and enable animations

```


And the last and not least install through your pkg manager Angular Experimental by running `npm i @angular/material-experimental`

##### Creating a "custom" Angular Material M3 Theme

As pointed at the documentation `Migrating to MDC-based Components` guide, the solution here purposed may change in the future as the Angular Material team evolves the framework.

> [!NOTE]
> [What Is Material 3](https://material.angular.io/guide/material-3#what-is-material-3)
> 
> As of v17.2.0, Angular Material includes experimental support for M3 styling in addition to M2. The team plans to stabilize support for M3 after a brief period in experimental in order to get feedback on the design and API.

And at the end of the guide there also a FAQ.

> [!NOTE]
> [FAQ](https://material.angular.io/guide/material-3#faq)
> 
> Can I use colors other than the pre-defined Material 3 palettes?
> 
> Currently, we only offer predefined palettes, but we plan to add support for using custom generated palettes as part of making the M3 APIs stable and available in `@angular/material`.

But looking at the shape of `predefined palettes` you can define your own by specifying each property in the same way by coping/pasting the palettes defined at `@forward './theming/m3-palettes'` inside `_index.scss` at `node_modules/@angular/material-experimental`

At your `style.scss` copy/paste a predefined theme and later on at this article we will generate a compatible M3 Theme using `@material/material-color-utilities` an official library for color utilities from Google Material team.
  
```scss
@use 'sass:map';
@use '@angular/material' as mat;
@use '@angular/material-experimental' as matx;

@include mat.core();

$m3-base-config: (
color: (
// Start of copying the $cyan-palette into PRIMARY color config
 primary: (
  0: #000000,
  10: #002020,
  20: #003737,
  25: #004343,
  30: #004f4f,
  35: #005c5c,
  40: #006a6a,
  50: #008585,
  60: #00a1a1,
  70: #00bebe,
  80: #00dddd,
  90: #00fbfb,
  95: #adfffe,
  98: #e2fffe,
  99: #f1fffe,
  100: #ffffff,
  secondary: ( // The pattern follows 
   ...
  ),
  neutral: ( //by only chaniging the tone 
   ...
  ),
  neutral-variant: (// and the source color
   ...
  ),
  error: ( // for each TonalPallete
   ...
  )
  //End of copying the $cyan-palette as primary color
  
  // For our "secondary" color we will apply directly
  // an aleready built in M3 theme palette
  tertiary: matx.$m3-violet-palette,

),

 typography: () // [Optional] Typography config,
 density: () // [Optional] Density config
)

//Using matx the new api for defining a M3 Theme
$angular-material-3-theme: matx.define-theme(
   map.set($m3-base-config, color, theme-type, light)
);

$angular-material-3-theme-dark: matx.define-theme(
   map.set($m3-base-config, color, theme-type, dark)
);

html,
body {
  height: 100%;
  margin: 0;
  // Apply the theme for all components. Matx is only for theme
  // @mat.core() still the API for applying the styles
  @include mat.all-component-themes(theme.$angular-material-3-theme);

// If you want to applly dark theme, just set .dark at Body
  .dark {
    @include mat.all-component-colors(theme.$angular-material-3-theme-dark);
  }
}

```

Now you might have Angular Material Components using M3 `$cyan-palette` and if copy and paste some components from the documentation you will see something similar to this.
![image](https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihbjj0c6RHDl4tQicxHGU3vG0-fRygZvP_TPpA0CqV8XzyPzZ0IhcqL-Pps9Wuk88j95vlJVkCJNqaaDadoprTbuCTu8Nmuvb1I=w2560-h972-rw-v1)
![image](https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihbjj0c6RHDl4tQicxHGU3vG0-fRygZvP_TPpA0CqV8XzyPzZ0IhcqL-Pps9Wuk88j95vlJVkCJNqaaDadoprTbuCTu8Nmuvb1I=w2560-h972-rw-v1)

Is noteworthy that all buttons **have the same color**, even copy pasting from the button documentation section example.
This is also mentioned at `Migrating to MDC-based Components` guide.

> [!NOTE]
> #### 
> [Using component color variants](https://material.angular.io/guide/material-3#using-component-color-variants)
>
> A number of components have a `color` input property that allows developers to apply different color variants of the component. When using an M3 theme, this input still adds a CSS class to the component (e.g. `.mat-accent`)
> 
> However, there are ***no built-in styles targeting these classes***. You can instead apply color variants by passing the `$color-variant` option to a component's `-theme` or `-color` mixins.

So, if you want to still use the old way to apply components colors you can add to your `style.scss` the compatibility mixin.

```scss
// style.scss
html,
body {
...
 @include matx.color-variants-back-compat($angular-material-3-theme);
}
```

And now everything may looks familiar again.

![image](https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihYa9G9dCaahHG_LNMBzXvPR4JGvfulLw6k24mjs6msayQYa_qFAABWwED09XAiCneHUvSdsPY5vXQPKpqCqpAEYkQTin3Iz8Nk=w2560-h972-rw-v1)


##### Understanding Angular Material M3 Theme changes based on [Design tokens](https://m3.material.io/foundations/design-tokens/overview)

Starting from Angular Material v15, M3 design tokens are represented by [custom properties](https://developer.mozilla.org/pt-BR/docs/Web/CSS/--*) and referenced as CSS variables instead of multiple CSS classes. By inspecting a `mat-flat-button`, we can observe this change.

```scss
//A lot of tokens for the mdc button
.mat-primary.mat-mdc-button-base {
  --mdc-text-button-label-text-color: #005cbb;
  --mdc-text-button-disabled-label-text-color: rgba(26, 27, 31,    .38);
  --mdc-protected-button-container-color: #fdfbff;
  --mdc-protected-button-label-text-color: #005cbb;
...
}
// And some class using it
.mat-mdc-unelevated-button {
  font-family: var(--mdc-filled-button-label-text-font);
  font-size: var(--mdc-filled-button-label-text-size);
  letter-spacing: var(--mdc-filled-button-label-text-tracking);
  font-weight: var(--mdc-filled-button-label-text-weight);
  text-transform: var(--mdc-filled-button-label-text-transform);
  height: var(--mdc-filled-button-container-height);
  border-radius: var(--mdc-filled-button-container-shape);
  padding: 0 var(--mat-filled-button-horizontal-padding, 16px);
}
```

If you inspect a little more, you may find the specific custom property that is defining the style you would like to change. Here is an example for `mat-flat-button`.

```scss
// The token somewhere
html, body {
...
--mdc-filled-button-container-color: #007dff;
...
}

// The actual classe generated from
// mat.all-component-themes(theme.$angular-material-3-theme)
.mat-mdc-unelevated-button:not(:disabled) {
 background-color: #007dff;
}
```

Unfortunately, Angular Material design token names differ slightly from those of [MDC Web Components](https://material-web.dev/about/intro/) and do not specify which tokens correspond to each CSS class or component. Furthermore, unlike the **[Material Web Components Color Tokens](https://material-web.dev/theming/color/#tokens)** documentation, Angular Material does not provide a set of generic design tokens to change the entire theme at once. For changing colors dynamically at runtime, manually inspecting each token and overriding it using a CSS variable is not ideal because you don't know the exact tone, shade, or function used to generate a specific token color.

However, after some research, I found a library called [material-color-utilities](https://github.com/material-foundation/material-color-utilities), which is a recently open-sourced library from Google that came along with their latest version of Material Design (M3). This library helps generate a theme from a source color, similar to their theme builder example, which you can check out at [Material 3 Theme Builder](https://material-foundation.github.io/material-theme-builder/).

![image](https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihZ-aO8Oq470dKKvQoJqhwnIE3S8BS1_rknjHC1Bma7DJYDivSuNGrnv8op4g8t1lc9aH7xliwm_SiMxAFqCnjBHtkimvczyA7M=w2560-h972-rw-v1)



##### Theming Angular Material 3 components with custom css properties

In your `style.scss`, instead of declaring hard-coded HEX values for primary and tertiary colors directly, we will create custom properties for each tone that can be generated from **material-color-utilities** and referenced as variables at the M3 Theme configuration. Later on, we will override these variables at the root of the application.


```scss
// Super fancy custom properties names
:root {
--primary-0: #000000;
--primary-10: #001f24;
--primary-20: #00363d;
--primary-25: #00424a;
--primary-30: #004f58;
--primary-35: #005b66;
--primary-40: #006874;
--primary-50: #068391;
--primary-60: #389eac;
--primary-70: #58b9c7;
--primary-80: #75d4e4;
--primary-90: #98f0ff;
--primary-95: #d0f8ff;
--primary-98: #edfcff;
--primary-99: #f6feff;
--primary-100: #ffffff;

--p-secondary-0: #000000;
--p-secondary-10: #001f24;
--p-secondary-20: #00363d;
--p-secondary-25: #00424a;
--p-secondary-30: #004f58;
--p-secondary-35: #005b66;
--p-secondary-40: #006874;
--p-secondary-50: #068391;
--p-secondary-60: #389eac;
--p-secondary-70: #58b9c7;
--p-secondary-80: #75d4e4;
--p-secondary-90: #98f0ff;
--p-secondary-95: #d0f8ff;
--p-secondary-98: #edfcff;
--p-secondary-99: #f6feff;
--p-secondary-100: #ffffff;

--p-neutral-0: #000000;
--p-neutral-10: #191c1c;
--p-neutral-20: #2e3131;
--p-neutral-25: #393c3c;
--p-neutral-30: #454748;
--p-neutral-35: #505353;
--p-neutral-40: #5c5f5f;
--p-neutral-50: #757778;
--p-neutral-60: #8f9191;
--p-neutral-70: #aaabac;
--p-neutral-80: #c5c7c7;
--p-neutral-90: #e1e3e3;
--p-neutral-95: #f0f1f1;
--p-neutral-98: #f9f9fa;
--p-neutral-99: #fbfcfc;
--p-neutral-100: #ffffff;

--p-neutral-variant-0: #000000;
--p-neutral-variant-10: #161d1e;
--p-neutral-variant-20: #2b3233;
--p-neutral-variant-25: #363d3e;
--p-neutral-variant-30: #414849;
--p-neutral-variant-35: #4d5455;
--p-neutral-variant-40: #586061;
--p-neutral-variant-50: #71787a;
--p-neutral-variant-60: #8b9293;
--p-neutral-variant-70: #a5acae;
--p-neutral-variant-80: #c1c8c9;
--p-neutral-variant-90: #dde4e5;
--p-neutral-variant-95: #ebf2f3;
--p-neutral-variant-98: #f4fbfc;
--p-neutral-variant-99: #f7fdff;
--p-neutral-variant-100: #ffffff;

--error-0: #000000;
--error-10: #410002;
--error-20: #690005;
--error-25: #7e0007;
--error-30: #93000a;
--error-35: #a80710;
--error-40: #ba1a1a;
--error-50: #de3730;
--error-60: #ff5449;
--error-70: #ff897d;
--error-80: #ffb4ab;
--error-90: #ffdad6;
--error-95: #ffedea;
--error-98: #fff8f7;
--error-99: #fffbff;
--error-100: #ffffff;

}

//
$m3-base-config: (
  color: (
  //Redefine the primary color based on your own css vars
    primary: (
      0: #000000, // 
      10: var(--primary-10),
      20: var(--primary-20),
      25: var(--primary-25),
      30: var(--primary-30),
      35: var(--primary-35),
      40: var(--primary-40),
      50: var(--primary-50),
      60: var(--primary-60),
      70: var(--primary-70),
      80: var(--primary-80),
      90: var(--primary-90),
      95: var(--primary-95),
      98: var(--primary-98),
      99: var(--primary-99),
      100: #ffffffff,
    secondary: (
      0: #000000,
      10: var(--p-secondary-10),
      20: var(--p-secondary-20),
      ...
     ),
    neutral: (
      0: #000000,
      10: var(--p-neutral-10),
      20: var(--p-neutral-20),
      ...
      100: #ffffffff,
     ),
    neutral-variant: (
      0: #000000,
      10: var(--p-neutral-variant-10),
      20: var(--p-neutral-variant-20),
      ...
      100: #ffffffff,
     ),
    error: (
      0: #000000,
      10: var(--error-10),
      20: var(--error-20),
      ...
      100: #ffffffff,
     )
   ),
   // You can do the same for you "secondary" color
   // which they call tertiary
   tertiary: (
   ...
   )
)
```

By doing this, Angular Material's internal mixins will create CSS variables that point to your CSS variables, resulting in an unexpected pointer of a pointer. If everything is done correctly, you should not notice any changes in your styles, only in the generated variables following the tokens from Material 3.

If you inspect your components tokens you might see:
```scss

//A lot of tokens for the mdc button pointing to your color vars
html, body {
  --mdc-text-button-label-text-color: #005cbb;
  --mdc-text-button-disabled-label-text-color: rgba(26, 27, 31,    .38);
  --mdc-filled-button-container-color: var(--primary-40);
  --mdc-protected-button-label-text-color: #005cbb;
  --mdc-fab-container-color: var(--primary-90);
  
  --mat-fab-small-foreground-color: var(--primary-10);
  --mat-fab-small-state-layer-color: var(--primary-10);
  --mat-fab-small-ripple-color: var(--primary-10);
  
  --mat-datepicker-calendar-period-button-text-color: var(--p-neutral-variant-30);
  --mat-datepicker-calendar-period-button-icon-color: var(--p-neutral-variant-30);
  --mat-datepicker-calendar-navigation-button-icon-color: var(--p-neutral-variant-30);
  --mat-datepicker-calendar-header-text-color:
...
}

```

Some custom properties may not change because they are not correlated with the theme colors configuration. However, now, you can at least more easily check which palette/tone is being used in all Material components and combine it with M2 utility functions.

> [!NOTE]
> #### 
> [Theme your own components using a Material 3 theme](https://material.angular.io/guide/material-3)
>
> The same utility functions for reading properties of M2 themes (described in [our guide for theming your components](https://material.angular.io/guide/theming-your-components)) can be used to read properties from M3 themes. However, the named palettes, typography levels, etc. available are different for M3 themes, in accordance with the spec.

For example, if you want to set a component's background to your secondary color, consider using the `S-90` color token. For text colors within this component background, use the `S-10` color token. Alternatively, you can automate this by using the utility functions and passing the `$role` as `secondary-container` and `on-secondary-container`, as suggested by the theme builder.

![image](https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihYocUswiuBvtlSJ4gvDBpmZ-9RwiPUKnG_Apw0yHuytc03oyciRENDfwt0gD5tEvhisFvbleQCb60MR1tWKw6xS0-AnjuXeU3o=w1362-h972-rw-v1)

Here is a code example:

```scss
//_button-theme.scss
@use 'sass:map';
@use '@angular/material' as mat;
@use './theme' as theme; //just a file where theme is set

@include mat.core();

.primary-button {
  color: mat.get-theme-color(
  theme.$angular-material-3-theme,
  inverse-on-surface // will generate a color based on css var
);
background-color: mat.get-theme-color(
  theme.$angular-material-3-theme,
  primary,
  70 // It will points to your custom css var token :)
 );
border-radius: 10px;
}
```

You can have a better understanding how to theme your components based at [Material 3 Theme Builder](https://material-foundation.github.io/material-theme-builder/) where you can check which color or role to use.

> [!warning]
> #### 
> Some MDC tokens use RGB functions that do not work as expected out of the box
> 
> One example I encountered was button ripple colors, where I had to explicitly hard code colors tones 100 and 0 (full black, full white) from each palette or override the token at the root.
> 
> Also some Angular Material components render elements that are not direct DOM descendants of the component's host elements, like Menus and Snackbars. You might define custom css classes for them.


##### Applying a dynamic runtime theme

Now it's time to implement the code that will override the custom properties when a source color is selected. The code snippet below provides a brief idea of how to achieve the runtime goal of changing Material M3 colors, and I strongly recommend looking at the source code here.

At `app.component.ts` 
```ts
export const DEFAULT_COLOR = '#8714fa';

export class AppComponent {
 color = signal(DEFAULT_COLOR);
 
 onColorChange(event: any) {
  this.color.set(event.value);
 }
}

```

At `app.comepontent.html` lets add some code for a color picker input
```html
<div class="theme-controls">
 <div class="color-picker-wrapper">
  <div class="color-picker-overflow">
   <input 
    matInput
    id="color-input"
    type="color"
    [(ngModel)]="color"
    (ngModelChange)="onColorChange($event)"
   />
  </div>
 </div>
</div>
```

Lets have some styles

```scss
.theme-controls {
  display: flex;
  gap: 0.65rem;
  align-items: center;
  margin: auto;

  .color-picker-wrapper {
    display: flex;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    position: relative;

    .color-picker-overflow {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 100%;
      height: 100%;
      overflow: hidden;
      border-radius: 50%;

      #color-input {
        cursor: pointer;
        border: none;
        background: none;
        min-width: 150%;
        min-height: 150%;
      }
    }
  }
}
```

Now we are going to use `@material-utilities-color` library o generate a M3 theme from the selected color

```ts
themeFromSelectedColor(color?: string, isDark?: boolean): void {

// All calculations are made using numbers
// we need HEX strings with some apis
const theme = themeFromSourceColor(
 argbFromHex(this.color() ?? DEFAULT_COLOR)
);

//Angular material tones
const tones = [0, 10, 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 95, 99, 100];

// A colors Dictionary 
const colors = Object.entries(theme.palettes).reduce(
 (acc: any, curr: [string, TonalPalette]) => {
 const hexColors = tones.map((tone) => ({ tone, hex:     hexFromArgb(curr[1].tone(tone)),
}));

return { ...acc, [curr[0]]: hexColors }; 
}, {});

// Then we will apply the colors to the DOM :root element
this.createCustomProperties(colors, 'p');
}

```


Then we will create the custom properties 

```ts
createCustomProperties(
 colorsFromPaletteConfig: colorsFromPaletteConfig,
 paletteKey: 'p' | 't',
) {

let styleString = ':root,:host{';
 
 for (const [key, palette] of     Object.entries(colorsFromPaletteConfig)) {
palette.forEach(({ hex, tone }) => {

  if (key === 'primary') {
   styleString += `--${key}-${tone}:${hex};`;
  } else {
   styleString += `--${paletteKey}-${key}-${tone}:${hex};`;
  }
 });
}

styleString += '}';

this.applyThemeString(styleString, 'angular-material-theme');
}
```

The last part we need to do is attach out custom properties to the DOM
```ts
applyThemeString(
  themeString: string, 
  ssName = 'angular-material-theme') 
{
let sheet = (globalThis as WithStylesheet)[ssName];

if (!sheet) {
 sheet = new CSSStyleSheet();
 (globalThis as WithStylesheet)[ssName] = sheet;
 this.#document.adoptedStyleSheets.push(sheet);
}
 sheet.replaceSync(themeString);
}

```

And this is the final result.
