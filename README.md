# Truffle Documentation

Public documentation for Truffle, Symphony, and the Truffile SDK, built with
[Mintlify](https://mintlify.com/).

### Development

Install the [Mintlify CLI](https://www.npmjs.com/package/mintlify):

```bash
npm i -g mintlify
```

From this repository's root, start the local preview:

```bash
mintlify dev
```

Validate changes before publishing:

```bash
mintlify validate
mintlify broken-links
bash scripts/check-public-content.sh
```

## Publishing

Changes pushed to `main` are deployed automatically. This is a public
repository: never commit app-review materials, invitations, access tokens,
support bundles, or internal working documents.
