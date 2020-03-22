
# Prettier 세팅

add eslint-config-aribnb with peer dependencies

```bash
yarn add --dev eslint
yarn add --dev eslint-config-airbnb-typescript --peer
yarn add --dev eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react eslint-plugin-react-hooks @typescript-eslint/eslint-plugin
yarn add eslint-config-prettier --dev
```

.eslintrc

```javascript
module.exports = {
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint"],
  extends: [
    "prettier",
    "airbnb-typescript",
    "prettier/react",
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking"
  ],
  parserOptions: {
    project: './tsconfig.json',
  },
  "rules": {
    // disable the rule for all files
    "@typescript-eslint/explicit-function-return-type": "off"
  },
};
```

.eslintignore

```none
/node_modules
```

.prettieryaml

```yaml
jsxBracketSameLine: true
printWidth: 120
semi: true
singleQuote: true
tabWidth: 2
trailingComma: 'es5'
```
