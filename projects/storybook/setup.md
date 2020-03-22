# 시작

automatic setup for react

```bash
mkdir storybook
cd storybook
yarn init -y
npx -p @storybook/cli sb init --type react
```

stories 폴더는 atom/module/page 별로 따로 생성할꺼기 때문에 삭제

```bash
rm -r ./stories
```

components/atoms 폴더 생성

```bash
mkdir components
```

.storybook/main.js 수정

```javascript
module.exports = {
  stories: ["../components/**/*.stories.tsx"],
  addons: [
    "@storybook/addon-actions",
    "@storybook/addon-links"
  ],
  webpackFinal: async config => {
    config.module.rules.push({
      test: /\.(ts|tsx)$/,
      use: [
        {
          loader: require.resolve('babel-loader'),
          options: {
            presets: [['react-app', { flow: false, typescript: true }]]
          }
        },
        {
          loader: require.resolve("react-docgen-typescript-loader")
        }
      ]
    });
    config.resolve.extensions.push(".ts", ".tsx");
    return config;
  }
};
```

mds typing 추가 ./components/typings.d.ts

```javascript
declare module '*.mdx';
```

setting up typescript with babel-loader

```bash
yarn add -D typescript babel-loader fork-ts-checker-webpack-plugin # for typescript
yarn add -D @storybook/addon-info react-docgen-typescript-loader # with recommend packages
yarn add -D jest "@types/jest" ts-jest # for testing
```

configure storybook's webpack by changing .storybook/main.js

```javascript

```

create .storybook/config.js

```javascript
import { configure } from '@storybook/react';

configure(require.context('../components', true, /\.stories\.(js|mdx|tsx)$/), module);
```

