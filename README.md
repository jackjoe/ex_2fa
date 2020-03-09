# Ex2fa

A small demo project to try out two-factor authentication in our Phoenix projects.

> Note
> This is just a demo project, it is NOT production ready.

# Flow

It contains a simple login flow with an existing user, inserted through a seed.

When logging in the `Auth` plug will check if the user has 2FA active. If so, redirects to the 2FA code page. If not, logs in as usual.

The dashboard shows a link to setup 2FA on a separate page. The QR code can be used in Authy, 1Password, ...

To get started:
```bash
make install
make run
```

## License

This software is licensed under [the MIT license](LICENSE.md).

## About Jack + Joe

Get to know our projects, get in touch. [jackjoe.be](https://jackjoe.be)
