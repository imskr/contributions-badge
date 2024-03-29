# contributions-badge

> A github action workflow for showcasing your number of merged pull requests in profile's README dynamically

<p align="center">
    <img src="public/images/logo.png" height="150"><br>
    <a href="https://github.com/imskr/contributions-badge/releases"><img alt="GitHub release (latest by date including pre-releases)" src="https://img.shields.io/github/v/release/imskr/contributions-badge?include_prereleases&style=flat-square"></a>
    <a href="https://github.com/imskr/contributions-badge/actions/workflows/build.yml"><img alt="Actions workflow" src="https://img.shields.io/github/actions/workflow/status/imskr/contributions-badge/build.yml?style=flat-square&logo=github"></a>
    <a href="https://github.com/imskr/contributions-badge/issues"><img alt="Github Issues" src="https://img.shields.io/github/issues/imskr/contributions-badge?color=orange&style=flat-square"></a>
</p>
<hr noshade>

## Usage

1. Go to your repository
2. Add the following to your **README.md** file, you can use any title. Just make sure that you use `<!-- MERGED_PULL_REQUESTS_COUNT --><!-- MERGED_PULL_REQUESTS_END -->` in your readme. The workflow will replace this comment with the number of merged pull requests:

    ```markdown
    <!-- MERGED_PULL_REQUESTS_START -->
    <!-- MERGED_PULL_REQUESTS_END -->
    ```

3. Create a folder `.github/workflows` inside root of the repository if it doesn't exists.
4. Create a new file `contributions.yml`  inside `.github/workflows/`  with the following contents or copy it from [here](./examples/contributions.yml):

![](./public/images/workflow.png)

5. Replace the above `organization`, `project`, `platform` and `username` with your data.
6. Commit and wait for it to run automatically, or you can also trigger it manually to see the result instantly.

> Currently we are only supporting public projects on platform GitLab and GitHub

## Results
![result](./public/images/result.png)

> See it in action [here](https://github.com/imskr/imskr/tree/master?tab=readme-ov-file#-open-source-contributions)

## Support

<p>
    <a href="https://buymeacoffee.com/imskr" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-red.png" alt="Buy Me A Coffee" width="150" ></a>
</p>
