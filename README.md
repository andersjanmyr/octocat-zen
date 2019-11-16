# octocat-zen

GitHub Actions workshop repository. The labs are in the [docs/README.md](https://github.com/octodemo/octocat-zen/tree/master/docs) document.

## NPM

### Install

```
npm install
```

### Run 

```
npm start
```

### Test

```
npm test
```

### Publish

```
npm publish --dry-run
```

### ESLint 

```
npm install eslint --save-dev
./node_modules/.bin/eslint --no-eslintrc .
```

## Docker

### Build Docker container 

```
docker build --rm -f "Dockerfile" -t octocat-zen .
```

### Run Docker container

```
docker run -d -p 8080:8080 --name octocat-zen octocat-zen:latest
```

### Stop container

```
docker container stop octocat-zen
```

### Remove container

```
docker container rm octocat-zen
```