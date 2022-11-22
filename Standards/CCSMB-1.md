# CCSMB-1: Procedures for Standards Submission

*Author: Tomodachi94 <@tomodachi94>*

*Version: v1.0.0*

*Last updated: 2022-11-07*

This RFC defines the protocol for defining and submitting a standard to the CCSMB.

## File Naming and Formatting

Each RFC should be named `CCSMB-n.md`, where `n` is a number counting upwards.

Each RFC should be a [GitHub-Flavoured Markdown](https://github.github.com/gfm/) document with British English spelling.

## Header

Each RFC should have the following immediately after the title:

```md
*Author: Your Name <@yourgithub>*

*Version: v1.0.0

*Last updated: YYYY-MM-DD*
```

To prevent commit spam, the "last updated" field should only be inserted before the PR is merged.

The version field should only be inserted immediately before the PR is merged.

## Tone

The RFC should be written in a professional tone. Readers are expected to have a basic understanding of programming jargon and Lua programming.

## Inclusion of Examples

Each RFC should include code for utilizing the standard. If the RFC is sufficiently complex, a reference implementation should be written and placed in the `/Standards/CCSMB-n` folder, where `n` is the RFC number.

In the case of a standardized file format, examples should be stored in `/Standards/CCSMB-n`.

## Submission

Each submission should be in the form of a GitHub pull request. To be accepted as a standard, said pull request should have three approving reviews and should be merged after that threshold has been met.

