# Secret loader Medium
Description and usage of [Secret Loader tool](https://github.com/guillaumeblaquiere/secret-loader) 
and in relation with [the medium article]() 

# Default format
The default format of the environment variable follow this pattern:

`<prefix><secret_name>[#<version>]`

Where:
* **prefix** is the environment variable identifier for the secret to load. It's required and `secret:` by default 
It's customizable (see bellow)
* **secret_name** is the name of your secret in secret manager. Required
* **version** is the version of the secret. One `#` is required before specifing the version. 
It's optional. If missing, the latest version is loaded

Example of values of environment variable:

```
secret:mySecret#2
```

# Customization
It's possible to customize the prefix defined in the environment variable by setting a flag in the call

 * **prefix** of the secret defined in the environment variables, default is `secret:`
 
 Example
```
 secret-loader -prefix super-secret:
```

# Limitation
For now, the service recover only the secret in the current project.

Open a feature request is you need to get secret from external project

# License

This library is licensed under Apache 2.0. Full license text is available in
[LICENSE](https://github.com/guillaumeblaquiere/secret-loader-medium/tree/master/LICENSE).
