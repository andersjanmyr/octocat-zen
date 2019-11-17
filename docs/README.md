# GitHub Actions workshop

This hands-on workshop provides a introduction to building pipeline workflows using GitHub Actions and creating your first GitHub Action using JavaScript, TypeScript or Docker.

## Agenda

- Introduction to GitHub Actions.
- Create a workflow with build, test, publish and deploy steps.
- Create a workflow that is triggered when an issue is opened.
- Create a JavaScript action using the tutorial.
- Create your own action using either JavaScript, TypeScript or Docker.
- Q&A

## Prerequisites

- A [verified](https://help.github.com/en/github/getting-started-with-github/verifying-your-email-address) [GitHub account](https://help.github.com/en/github/getting-started-with-github/signing-up-for-a-new-github-account).
- We use a public repository under your personal account to run workflows.
- We use [Zeit](https://zeit.co/) for deployments.

:warning: Make sure to [configure two-factor-authentication](https://help.github.com/en/github/authenticating-to-github/configuring-two-factor-authentication) for your GitHub account.

At the end of each labs you will find links to relevant resources.

**Tip:** follow the `if applied, this commit will <your subject line here>` best practice for every commit message so you know what is being tested by the build run. For example:

>Add build and test workflow

### Resources

- [Core concepts for GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/core-concepts-for-github-actions)
- [Automating your workflow with GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions) 
- [Event Types & Payloads](https://developer.github.com/v3/activity/events/types/)
- [About pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests)

---
## Lab 1: Create repository from template

Create a new repository from [octocat-zen](https://github.com/octodemo/octocat-zen):

- Visit https://github.com/octodemo/octocat-zen.
- Click `Use this template`.
- Create a public repository under your personal account.
- Provide a repository name, for example `<your handle>-octocat-zen`.
- Click `Create repository from template`.
- If you want to use your favorite editor, you can clone the repository to your local machine.
- In `package.json` update the `name` and `repository` and commit the change.
- In `.npmrc` update the scope ands commit the change.

### Resources

- [Creating a repository from a template](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template)
- [Editing files in your repository](https://help.github.com/en/github/managing-files-in-a-repository/editing-files-in-your-repository)

---
## Lab 2: Add starter workflow

Let's get started with GitHub Actions:

- Click the `Actions` tab.
- Under Build and test your JavaScript repository select `Node.js`.
- Click `Setup this workflow`.
- Under `Start commit` select `Create a new branch`.
- Add a branch name, for example `add-nodejs` and click `Propose new file`.
- Provide a pull request title and description and click `Create pull request`.
- GitHub will start the build, go to the `Checks` tab to follow the build process.
- Merge the pull request and delete the feature branch.

**Note:** GitHub Actions are free for public repositories and on a free plan you get 2000 build minutes.

**Bonus:** make a change in a new pull request that breaks the build.

For example you could add an array test in `test.js`:

```javascript
var assert = require('assert');

[...]

describe('Array', function () {
  describe('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      // replace 4 with value that is present in the array
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });
});
 ```

### Resources

- [Starter workflows](https://github.com/actions/starter-workflows)
- [Matrix builds](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow#configuring-a-build-matrix)
- [npm-ci](https://docs.npmjs.com/cli/ci.html)
- [npm-test](https://docs.npmjs.com/cli/test.html)
- [npm-build](https://docs.npmjs.com/cli/build.html)
- [Mocha](https://mochajs.org/#getting-started)

---
## Lab 3: Add a linter step

In this lab we remove the matrix build and add a linter step:

- Go to `.github/workflows/nodejs.yml` and click on edit.
- Remove the following lines:

```yaml
strategy:
  matrix:
  node-version: [8.x, 10.x, 12.x]
```

- Replace `${{ matrix.node-version }}` with `12.x`
- Add a new step:

```yaml
- name: Run linter
  run: |
    npm install eslint --save-dev
    ./node_modules/.bin/eslint --no-eslintrc .
```

- Commit the changes to a new branch like `add-linter` and open a pull request.
- Visit the checks tab to follow the workflow run.

**Note** On GitHub Marketplace you can also find various [actions for ESLint](https://github.com/marketplace?utf8=%E2%9C%93&type=actions&query=ESLint) and other [code quality tools](https://github.com/marketplace?category=code-quality&type=actions). 

### Resources

- [steps](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobsjob_idsteps)
- [ESLint](https://eslint.org/)
- [npm-install](https://docs.npmjs.com/cli/install)

---
## Lab 4: Define a job level environment variable

You can use environment variables at the step and job level: 

- Add the following lines under the job `build`:

```yaml
env:
  NODE_VERSION: 12.x
```

- Change all occurrences of `12.x` to `${{ env.NODE_VERSION }}`.
- Commit the change to the `add-linter` branch.
- Check the build run.
- Merge the pull request and delete the branch.

### Resources 

- [Env at the workflow and job level](https://github.blog/changelog/2019-10-01-github-actions-new-workflow-syntax-features/#env-at-the-workflow-and-job-level)

---
## Lab 5: Dump contexts

In this lab we add another workflow to take a look at the workflow context. We will also look at a few functions:

- In `.github/workflows/` create a new file, for example: `dump-context.yml`
- Add the following content:

```yaml
name: Dump contexts

on: push

jobs:
  echo:
    runs-on: ubuntu-16.04
    steps:
      - name: Dump GitHub context
        env:
          GITHUB_CONTEXT: ${{ toJson(github) }}
        run: echo "$GITHUB_CONTEXT"
      - name: Dump job context
        env:
          JOB_CONTEXT: ${{ toJson(job) }}
        run: echo "$JOB_CONTEXT"
      - name: Dump steps context
        env:
          STEPS_CONTEXT: ${{ toJson(steps) }}
        run: echo "$STEPS_CONTEXT"
      - name: Dump runner context
        env:
          RUNNER_CONTEXT: ${{ toJson(runner) }}
        run: echo "$RUNNER_CONTEXT"
```

- Commit the changes to a new branch like `dump-context` and open a pull request.
- Visit the `Checks` tab to follow the workflow run.
- Add a step that outputs the following variables from the GitHub context:
  - `github.event_name`
  - `github.ref`
- For example:

```yaml
- name: Dump variables
  env:
    EVENT_NAME: ${{ github.event_name }}
    REF: ${{ github.ref }}
  run: echo "Event name $EVENT_NAME and ref $REF"
```

- The `toSJON()` is an example of a [built-in function](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#functions).
- Add the following function to the last `Dump variables` step:

```yaml
format('Hello {0} {1} {2} {3}', 'Hubot', 'the', 'friendly', 'robot')
```

- For example:

```yaml
- name: Outputs 
  env:
    EVENT_NAME: ${{ github.event_name }}
    REF: ${{ github.ref }}
    ROBOT: ${{ format('Hello {0} {1} {2} {3}', 'Hubot', 'the', 'friendly', 'robot') }}
  run: |
    echo "Event name $EVENT_NAME and ref $REF"
    echo "$ROBOT"
```

You can process the variables like any other environment variable, for example to replace `Hubot` with `Probot`:

```bash
echo "${ROBOT/Hubot/Probot}"
```

- Feel free to try a couple of other functions.
- Merge the pull request and delete the feature branch.

### Resources 

- [Contexts](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#contexts)
- [Functions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#functions)

---
## Lab 6: Add a comment to the pull request 

Let's add a comment to thank the developer for opening the pull request. We will use an `if` statement to check if the pull request is `opened` as we only want to add the comment once.

You can add `if` statements both on the `step` and `job` level. You can also use `or` operators (`||`):

```yaml
if: github.event_name == 'pull_request' && (github.event.action == 'opened' || github.event.action == 'reopened')
```

And `and` operators (`&&`):

```yaml
if: github.event_name == 'pull_request' && github.event.action == 'closed'
```

And combine operators with functions:

```yaml
if:  github.event.action == 'opened' && ( startsWith(github.event.issue.title, 'demo') )
```

- Go to `.github/workflows/nodejs.yml` and click on edit.
- Add the following step after the `checkout` step, we will use `actions/github` to add the comment to the pull request: 

```yaml
- name: Add comment 
  if: github.event_name == 'pull_request' && (github.event.action == 'opened')
  uses: actions/github@v1.0.0
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    with:
      args: comment "Thank you for opening this pull request :tada::sparkles:"
```

- Commit the changes to a new branch like `add-comment` and open a pull request.
- Visit the checks tab to follow the workflow run.
- Merge the pull request and delete the feature branch.

### Resources

- [Contexts and expression syntax for GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#functions)
- [actions/github](https://github.com/actions/github)

---
## Lab 7: Add caching for `node_modules`

Actions allow you to cache dependencies and build outputs in GitHub Actions:

- Go to `.github/workflows/nodejs.yml` and click on edit.
- Add the following step after the checkout step:

```yaml
- uses: actions/cache@v1
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

- Commit the changes to a new branch like `add-caching` and open a pull request.
- Visit the checks tab to follow the workflow run.
- Make another code change to verify if the cache gets restored, for example add a step name:

```yaml
- name: Cache dependencies
```

- Merge the pull request and delete the feature branch.

You can also upload and download build artifacts, for example if you want to use build artifacts across different jobs in a workflow:

```yaml
- name: Upload report
  uses: actions/upload-artifact@master
    with:
      name: coverage
      path: ${{ github.workspace }}/coverage
```


### Resources

- [GitHub Actions adds dependency caching](https://github.blog/changelog/2019-11-04-github-actions-adds-dependency-caching/)
- [actions/cache](https://github.com/actions/cache) 
- [upload-artifact](https://github.com/actions/upload-artifact)
- [download-artifact](https://github.com/actions/download-artifact)

---
## Lab 8: Deploy to Zeit 

It is time to deploy our code. For this workshop we use Zeit as deployment target:

- Visit https://zeit.co/ and create an account using GitHub OAuth or email. 
- Go to Settings, then Tokens and generate a token.
- Copy the token.
- Go to the GitHub repository and visit `Settings`, `Secrets` and add a secret for the token with key `ZEIT_TOKEN`.
- Go to `.github/workflows/nodejs.yml` and click on edit.
- Add the following step to the workflow:

```yaml
- name: Deploy to Zeit
  uses: amondnet/now-deployment@v1
    with:
      github-token: ${{ secrets.GITHUB_TOKEN }}
      zeit-token: ${{ secrets.ZEIT_TOKEN }}
```

- Commit the changes to a new branch like `add-deployment` and open a pull request.
- Visit the `Checks` tab to follow the workflow run.
- If the run is successful you should see the deployment url created by Zeit.
- Visit the url to check our deployment.
- Navigate to the project in Zeit to view the deployment details.

**Bonus:** Update the workflow to only run when the branch is `master` or update to run the deployment step only when the branch is `master`. After this task, remove any branch filters and commit.

- Do not merge the pull request yet.

### Resources

- [Zeit](https://zeit.co/)
- [Introducing API Tokens Management](https://zeit.co/blog/introducing-api-tokens-management)
- [amondnet/now-deployment](https://github.com/amondnet/now-deployment)
- [Creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)

---
## Lab 9: Add the deployment to the pull request

With the Deployment API you can report a deployment status in the pull request:

- Change the workflow event from `push` to `pull_request`.
- Add the following step before the Zeit deployment step:

```yaml
- uses: octokit/request-action@v1.x
  id : create_deployment
  with:
    route: POST /repos/:owner/:repo/deployments
    ref: ${{ github.event.pull_request.head.ref }}
    required_contexts: "[]"
    environment: "review"
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- We need to capture the deployment `id` from the response. We can use a tool like `jq` to do that in a script, but we can also use the following action:

```yaml
- uses: gr2m/get-json-paths-action@v1.x
  id: parse_deployment
  with:
    json: ${{ steps.create_deployment.outputs.data }}
    id: "id"
```

- To update the deployment statuses, add the following steps after the Zeit deployment step:

```yaml
- uses: octokit/request-action@v1.x
  with:
    route: POST /repos/:owner/:repo/deployments/:deployment_id/statuses
    deployment_id: ${{ steps.parse_deployment.outputs.id }}
    environment: "review"
    state: "success"
    target_url: ${{ steps.zeit_deployment.outputs.preview-url }}
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

- uses: octokit/request-action@v1.x
  if: failure()
  with:
    route: POST /repos/:owner/:repo/deployments/:deployment_id/statuses
    deployment_id: ${{ steps.parse_deployment.outputs.id }}
    environment: "review"
    state: "failure"
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- Verify the build run.
- Merge the pull request and delete the feature branch.

### Resources

- [octokit/request-action](https://github.com/octokit/request-action)
- [gr2m/get-json-paths-action](https://github.com/gr2m/get-json-paths-action)
- [Deployments API](https://developer.github.com/v3/repos/deployments/)
- [Outputs](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#steps-context) 

---
## Lab 10: Publish mpn package

In this lab we will publish our project as npm package to GitHub Package Registry.

- Add the following job to the workflow:

**Note:** make sure to your handle to the scope.

```yaml
publish-gpr:
  needs: build
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v1
    - uses: actions/setup-node@v1
      with:
        node-version: 12.x
        registry-url: https://npm.pkg.github.com/
        scope: '@<your handle>'
    - run: npm ci
    - run: npm publish
      env:
        NODE_AUTH_TOKEN: ${{secrets.GITHUB_TOKEN}}
```
- Now we might just want to run this when we push to `master`, so create a separate workflow that will deploy on a push to `master`.

### Resources

- [jobs](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobs)
- [actions/setup-node](https://github.com/actions/setup-node)
- [npm-ci](https://docs.npmjs.com/cli/ci.html)
- [npm-publish](https://docs.npmjs.com/cli/publish)

---
## Lab 11: Add a badge 

Let's add a badge to the `README`:

- Go to the `README`, select the pull request branch and open the file in the edit mode.
- Add the following line under the title:

```
![](https://github.com/<owner>/<repository>/workflows/Node%20CI/badge.svg)
```

- Commit the change to the pull request branch.
- Visit the `README` in the pull request branch after the build completes.
- Optionally make another change that will break the build and verify again.
- Merge the pull request and delete the feature branch.

### Resources

- [Adding a workflow status badge to your repository](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow#adding-a-workflow-status-badge-to-your-repository)

---
## Lab 12: Publish Docker container

GitHub Package Registry can also be used to publish Docker images.

Create a new job `publish-docker` that builds and tags the image and then publishes the tagged image to GitHub Package Registry:

**Note:** make sure to update the tag names to reflect your handle and repository name.

```yaml
publish-docker:
  needs: [build]
  runs-on: [ubuntu-latest]
  steps:
  - uses: actions/checkout@master
  - run: |
      docker build -t docker.pkg.github.com/<your handle/octocat-zen/octocat-zen:${{ github.sha }} .
      docker login docker.pkg.github.com -u <your handle> -p $GITHUB_TOKEN
      docker push docker.pkg.github.com/<your handle>/octocat-zen/octocat-zen:${{ github.sha }}
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  ```

### Resources

- [Configuring Docker for use with GitHub Packages](https://help.github.com/en/github/managing-packages-with-github-packages/configuring-docker-for-use-with-github-packages)

---
## Lab 13: Create release 

For a JavaSCript project you can use `semantic-release` to automatically create releases. This is a bit harder to test as it will closely examine your commits to judge if it justifies a release.

```yaml
on:
  push:
    branches:
      - master
      - next

name: Release
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: actions/setup-node@v1
        with:
          node-version: "12.x"
      - run: npx semantic-release -r git@github.com:<your handle>/octocat-zen.git
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- You can also create releases using the [Releases API](https://developer.github.com/v3/repos/releases/) or the [create-release](https://github.com/actions/create-release) action, but this requires you to add the versioning and changelog manually. 

### Resources

- [semantic-release](https://github.com/semantic-release/semantic-release)

---
## Lab 14: Use the issue event

In the following example we will use the issue event to add a comment to an issue when it is created. We use `actions/github` to comment on the issue when it is opened.

- Create a new workflow file in `.github/workflows` for example called `zen-comment.yml`:

```yaml
name: GitHub Zen

on:
  issues:
    types: [opened]

jobs:
  build:
    runs-on: ubuntu-latest   
  
    steps:  
  
    - id: zen
      run: echo ::set-output name=quote::$(curl https://api.github.com/zen)

    - name: GitHub Zen comment
      uses: actions/github@v1.0.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        args: comment ">${{ steps.zen.outputs.quote }} :heart::octocat:"
```
- You can also use `actions/github` to assign a user to an issue or apply a label. See [entrypoint.js](https://github.com/actions/github/blob/master/entrypoint.js) for examples.
- As an alternative you can also use `request-action`:

```yaml
- name: GitHub zen comment
  uses: octokit/request-action@v1.x
    with:
      route: POST /repos/:owner/:repo/issues/:issue_number/comments
      issue_number: ${{ github.event.issue.number }}
      body: '">${{ steps.zen.outputs.quote }} :heart::octocat:"'
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
- And there is another way of doing this using [github-script](https://github.com/actions/github-script). This action is under development.

### Resources

- [GitHub Action for GitHub](https://github.com/actions/github)
- [octokit/request-action](https://github.com/octokit/request-action)
- [github-script](https://github.com/actions/github-script)
- [cURL](https://curl.haxx.se/)
- [Issues](https://developer.github.com/v3/issues/)
- [IssuesEvent](https://developer.github.com/v3/activity/events/types/#issuesevent)
- [Outputs](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions#steps-context) 
- [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)

---
## Lab 15: Creating a JavaScript action

Follow the tutorial [Creating a JavaScript action](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-a-javascript-action) to create your first JavaScript action.

You can also [use Docker to create actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-a-docker-container-action).

### Resources 

- [Building actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/building-actions)
- [Development tools for GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/development-tools-for-github-actions)
- [Publishing actions in GitHub Marketplace](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/publishing-actions-in-github-marketplace)
- [zeit/ncc](https://github.com/zeit/ncc)
- [GitHub Actions](https://github.com/actions)
- [Working with GitHub Actions](https://jeffrafter.com/working-with-github-actions/)

---
## Lab 16: Create your own action 

- Create small teams of two to three people. 
- Start with brainstorming to come up with a great idea for a GitHub Action that can help you to improve your workflow. Remember that you can use [any event on GitHub](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows).
- Build and test your action.
- Add documentation in the README.
- Provide a sample workflow.
- Prepare to present your action to the workshop audience.  

If you want to interact with GitHub you can install and import the `@actions/github` library and create a `client`:

```javascript
import * as core from '@actions/core';
import * as github from '@actions/github';
import * as yaml from 'js-yaml';

async function run() {
  try {
    const ref = core.getInput('ref', { required: true });
    const task = core.getInput('task');
    const autoMerge: boolean = yaml.load(core.getInput('auto_merge'));

    const client = new github.GitHub(token);

    core.debug('Returning the ref value');

    core.setOutput('ref', ref)

  } catch (error) {
    core.setFailed(error.message);
  }
}
```

---
## Scheduled events and dispatcher event

### Scheduled events

GitHub Actions also supports scheduled events. See [actions/stale](https://github.com/actions/stale) for an example. 

### Dispatch event

You can use the GitHub API to trigger a webhook event called `repository_dispatch` when you want to trigger a workflow for activity that happens outside of GitHub.
 
### Resources

- [Scheduled events: `schedule`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows#scheduled-events-schedule)
- [Create a repository dispatch event](https://developer.github.com/v3/repos/#create-a-repository-dispatch-event)
- [External events: `repository_dispatch`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows#external-events-repository_dispatch)

---
## Appendix 1: the complete `nodejs.yml` workflow

The following workflow is an example of the completed `nodejs.yml` workflow:

**Note:** if you want to use this workflow please updated the owner value to match your handle and make sure you use your repository path and name.

```yaml
name: Node CI

on: [pull_request]

jobs:
  build:
    env:
      NODE_VERSION: 12.x
    
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v1
    
    - name: Add comment 
      if: github.event_name == 'pull_request' && (github.event.action == 'opened' || github.event.action == 'reopened')
      uses: actions/github@v1.0.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        args: comment "Thank you for opening this pull request :tada::sparkles:"
      
    - name: Cache dependencies
      uses: actions/cache@v1
      with:
        path: ~/.npm
        key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
        restore-keys: |
          ${{ runner.os }}-node-
    
    - name: Use Node.js ${{ env.NODE_VERSION }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ env.NODE_VERSION }}
    
    - name: npm install, build, and test
      run: |
        npm ci
        npm run build --if-present
        npm test
      env:
        CI: true

    - name: Run linter
      run: |
        npm install eslint --save-dev
        ./node_modules/.bin/eslint --no-eslintrc .
    
    - uses: octokit/request-action@v1.x
      id: create_deployment
      with:
        route: POST /repos/:owner/:repo/deployments
        ref: ${{ github.event.pull_request.head.ref }}
        required_contexts: "[]"
        environment: "review"
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

    - uses: gr2m/get-json-paths-action@v1.x
      id: parse_deployment
      with:
        json: ${{ steps.create_deployment.outputs.data }}
        id: "id"

    - name: Deploy to Zeit
      uses: amondnet/now-deployment@v1
      id: zeit_deployment
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        zeit-token: ${{ secrets.ZEIT_TOKEN }}

    - uses: octokit/request-action@v1.x
      with:
        route: POST /repos/:owner/:repo/deployments/:deployment_id/statuses
        deployment_id: ${{ steps.parse_deployment.outputs.id }}
        environment: "review"
        state: "success"
        target_url: ${{ steps.zeit_deployment.outputs.preview-url }}
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

    - uses: octokit/request-action@v1.x
      if: failure()
      with:
        route: POST /repos/:owner/:repo/deployments/:deployment_id/statuses
        deployment_id: ${{ steps.parse_deployment.outputs.id }}
        environment: "review"
        state: "failure"
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  publish-gpr:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions/setup-node@v1
        with:
          node-version: 12.x
          registry-url: https://npm.pkg.github.com/
          scope: '@<your handle>s'
      - run: npm ci
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{secrets.GITHUB_TOKEN}}
                   
  publish-docker:
    needs: [build]
    runs-on: [ubuntu-latest]
    steps:
    - uses: actions/checkout@master
    - run: |
          docker build -t docker.pkg.github.com/<yourhandle>/octocat-zen/octocat-zen:${{ github.sha }} .
          docker login docker.pkg.github.com -u <your handle> -p $GITHUB_TOKEN
          docker push docker.pkg.github.com/<your handle>/octocat-zen/octocat-zen:${{ github.sha }}
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Appendix 2: Popular actions 

The number of community GitHub Actions is [fast growing](https://github.com/marketplace?type=actions). Here are some actions for commonly used tools and services: 

### Cloud providers

- [AWS](https://github.com/aws-actions/)
- [Google Cloud](https://github.com/googlecloudplatform/github-actions/)
- [Azure](https://github.com/Azure/actions/)

### Other popular tools

- [Atlassian JIRA](https://github.com/marketplace?utf8=%E2%9C%93&type=actions&query=jira)
- [SonarCloud](https://github.com/marketplace/actions/sonarcloud-scan)
- [JFrog CLI](https://github.com/marketplace/actions/setup-jfrog-cli)
- [Vault Secrets](https://github.com/marketplace/actions/vault-secrets)
- [Run mabl tests](https://github.com/marketplace/actions/run-mabl-tests)
- [Close Stale Issues](https://github.com/marketplace/actions/close-stale-issues)
- [GitHub Actions](https://github.com/actions)

### See also 

- [Powering community-led innovation with GitHub Actions](https://github.blog/2019-11-14-powering-community-led-innovation-with-github-actions/)
- [A thousand community-powered workflows using GitHub Actions](https://github.blog/2019-11-06-a-thousand-community-powered-workflows-using-github-actions/)
