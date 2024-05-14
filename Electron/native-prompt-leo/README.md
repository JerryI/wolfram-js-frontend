# `native-prompt`
Create native prompts with Node.js and Electron

# What is this?
While `alert` and `confirm` are both supported in Electron, `prompt` isn't (see [this issue](https://github.com/electron/electron/issues/472)). `native-prompt` aims to fix this by allowing you to create prompt boxes that are native to the user's OS. As an added bonus, it also works in Node.js.

# Screenshots
## Windows
![A prompt showing on Windows](https://raw.githubusercontent.com/ssight/native-prompt/master/screenshots/Windows.png)
## Linux
![A prompt showing on Linux](https://raw.githubusercontent.com/ssight/native-prompt/master/screenshots/Linux.png)
## MacOS
![A prompt showing on MacOS](https://raw.githubusercontent.com/ssight/native-prompt/master/screenshots/MacOS.png)

# Installation
### Through [NPM](https://www.npmjs.com/package/native-prompt):
>`npm i native-prompt`
### ...or the long way:
>`npm install native-prompt@latest --save`

# Usage
## Synopsis
```js
prompt (title, body, options)
```
### `title:string`
>The title you want to display at the top of the window
### `body:string`
>Any helpful text to go inside the message box
### `options: { defaultText?: string; mask?: boolean; okButtonLabel?: string; cancelButtonLabel?: string }`
>Any (optional) extra options (see below)

## Options
### `defaultText?: string`
>The text you want to already be in the input box beforehand
### `mask?: boolean`
>Whether you want the box to have a hidden input
### `okButtonLabel?: string`
>The label for the "ok" button, it only works on windows and linux and by default in linux it is not set and in windows it is set as "Ok"
### `cancelButtonLabel?: string`
>The label for the "cancel" button, it only works on windows and linux and by default in linux it is not set and in windows it is set as "Cancel"

## Examples
### Importing
#### Javascript
```js
const prompt = require('native-prompt')
```
#### Typescript
```ts
import prompt from 'native-prompt'
```
---
### Async function usage
```js
(async () => {
    const text = await prompt("This is a title.", "What would you really like to see next?", { defaultText: "Nothing" });
    if (text) {
        // Do something with the input
    } else {
        // The user either clicked cancel or left the space blank
    }
})()
```
### Regular promise usage
```js
prompt("This is a title.", "What would you really like to see next?", { defaultText: "Nothing" }).then(text => {
    if (text) {
        // Do something with the input
    } else {
        // The user either clicked cancel or left the space blank
    }
})
```

### Masked textbox example
```js
(async () => {
    const password = await prompt("Login", "Enter your password to log back in.", { mask: true });
    if (isCorrectPassword(password)) {
        // Log the user in
    } else {
        // The user's entered their username or password incorrect
    }
})()
```

### Ok and Cancel buttons modified example
```js
(async () => {
    const text = await prompt("Your Name", "Write your name.", { okButtonLabel: "Submit", cancelButtonLabel: "Abort" });
    if (text) {
        // Do something with the input
    } else {
        // The user either clicked cancel or left the space blank
    }
})()
```

# Notes
* If you plan on using `asar` to package your electron app, make sure to read [this](https://github.com/ssight/native-prompt/wiki/Usage-with-asar)
* For differences between 1.x and 2.x, see [this](https://github.com/ssight/native-prompt/wiki/Differences-between-1.x-and-2.x) wiki page.