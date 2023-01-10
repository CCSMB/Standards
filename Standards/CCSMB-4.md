# CCSMB 4: Recommendations for Lua Code
| | |
|-:|:-|
| **Author** | JackMacWindows |
| **Version** | v1.0.0 |
| **Date** | 2022-11-12 |

# 0. Abstract
This standard is meant to formalise many commonly recommended practices in the ComputerCraft community. This includes things such as file format and content, usage of globals, type checking, library format, and more. The CCSMB recognizes the benefits of following these practices, and RECOMMENDS that software developers follow them when writing ComputerCraft code. However, the CCSMB does not want to place unilateral requirements on all developers, so all recommendations made here are to be implemented at the developer's discretion.

The document is divided into two main classifications of guidelines: interface guidelines, and style guidelines. Interface guidelines indicate practices that are important in a program or library's interactions with other code. Style guidelines are purely for ease of use, cleanliness, and readability by the developer, and do not impact other programs like interface guidelines do. For code to be considered compliant with CCSMB 4, all interface guidelines MUST be implemented to specification, while style guidelines MAY be implemented as the developer sees fit. The following declaration MAY be used in code that is compliant with CCSMB 4:

"This [library|program] follows the CCSMB 4 standard for code design, which is available at https://ccsmb.github.io/standards/ccsmb-4."

Code that follows *part* of CCSMB 4 MAY declare partial compatibility, but MUST make its partial compatibility clear. For example, code that only follows sections 1.1 and 1.2 of this document may use this line:

"This [library|program] follows specifications 1.1 and 1.2 of the CCSMB 4 standard for code design, which is available at https://ccsmb.github.io/standards/ccsmb-4. However, it does not implement the complete standard."

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

# 1. Interface Guidelines

## 1.1. File Format
**1.1.1.** Lua files MUST be plain-text files as specified in [CCSMB 2](https://ccsmb.github.io/standards/ccsmb-2). This means only UTF-8 text is accepted, and Lua files MUST be opened in text mode (`"r"`/`"w"`).

**1.1.2.** Lua files SHOULD have the extension `.lua`, but older programs MAY accept no extension as well.

**1.1.3.** Code intended for distribution MUST have a licence statement located near or at the top of the file. This can be any statement of licence, including "all rights reserved" or "public domain". The CCSMB RECOMMENDS using one of the following licence types:

* CC0 or Unlicense or Public Domain
* MIT or ISC or zlib
* BSD (3-clause or 2-clause)
* Lesser GNU Public License (v2 or v3)
* GNU Public License (v2 or v3)
* All rights reserved (ARR)

For GPL-family licenses, the CCSMB RECOMMENDS that libraries use LGPL over GPL, and programs use GPL over LGPL.

## 1.2. Library Interface
**1.2.1.** Libraries MUST use the Lua 5.2+ style of library declaration. This means libraries MUST only export their code through a single `return` statement at the end of the file, which returns a single value with the exported data. The value SHOULD be a table or a string, and MUST NOT be `nil`.

**1.2.2.** Libraries MUST NOT create any global or environment variables, whether in the main chunk or inside a function, unless explicitly specified by the function documentation.

**1.2.3.** Libraries MUST NOT modify the `package.loaded` table to export their functions. This includes use of functions similar to Lua 5.1's `module` function (which is not available in base ComputerCraft).

**1.2.4.** Libraries MUST be loadable by the `require` function, and SHOULD be loadable by the `dofile` function if the library doesn't use `require` to load dependencies.

**1.2.5.** Libraries MUST NOT be compatible with `os.loadAPI`, and SHOULD NOT use `os.loadAPI` to load dependencies. Libraries which use dependencies that originally require `os.loadAPI` SHOULD import modified versions of those dependencies where possible. If an `os.loadAPI` dependency cannot be converted, libraries MUST NOT overwrite any previous global with the API's name after exiting the library code.

The following code demonstrates how to safely use `os.loadAPI` in a library compliant with this specification:

```lua
local foo                  -- forward declaration
do                         -- `do` block to contain the `oldfoo` variable
    local oldfoo = _G.foo  -- store the old value temporarily
    os.loadAPI("foo.lua")  -- load the API as a global
    foo = _G.foo           -- store the loaded API in a local variable
    _G.foo = oldfoo        -- replace the `foo` global with its previous value (which may be `nil`)
end
```

**1.2.6.** Functions exported by libraries MUST check the types of parameters passed to the function before using them. This includes checking for non-`nil` arguments, checking for correct argument types, checking for correct table field types, checking for correct argument ranges/possible values, and coalescing optional arguments. Libraries SHOULD use the `cc.expect` library (or comparable library for non-CraftOS operating systems) for type checking.

**1.2.7.** Functions and variables exported by libraries MUST have a name that describes what the member does in some way. Names that are either extremely short (e.g. single-letter) or irrelevant to the member's purpose are not allowed under this guideline.

## 1.3. Program Interface
**1.3.1.** Programs MUST NOT add or modify any variables or functions in `_G` unless explicitly required for the program to function with proper documentation.

# 2. Style Guidelines

## 2.1. General Code Style
**2.1.1.** All code SHOULD have proper indentation on every line of code. This means adding a certain number of indentations (which MAY be a set number of spaces or a single tab character) before the start of text on each line.

The start of the file has an indentation level of 0. For every keyword in (`do`, `else`, `function`, `repeat`, `then`, `{`), the indentation level *for the following lines* is increased by 1. For every keyword in (`else`, `elseif`, `end`, `until`, `}`), the indentation level *for that line and all following lines* is decreased by 1. Multi-line strings are exempt from this rule, and no indentation is required while inside a multi-line string.

The following code follows this rule:

```lua
local firstLine = "hello"
local function foo()
    if firstLine == "a" then print("This is a test")
    elseif type(firstLine) == "number" then
        firstLine = {
            count = firstLine,
            bar = true,
            longText = [[
This is a very long string of text that requires using a multi-line string
to be able to properly hold all of the information stored inside it.
Because it's so long, it's exempt from any indentation requirements.]]
        }
    else
        firstLine = 0
        while firstLine ~= 17
        do
            -- mix of newline styles
            do
                local a = firstLine
                firstLine = a + 1
            end
            repeat firstLine = firstLine * 2
            until firstLine >= 17
            firstLine = firstLine / 2
        end
    end
    return firstLine
end
print(foo())
```

**2.1.2.** Variables that are not used for temporary values or iterator storage SHOULD have full names with proper words or combinations of words in the writer's chosen language. These names SHOULD indicate what the variable is meant to store, and potentially the type of the variable (as in Hungarian notation).

## 2.2. Library Style
**2.2.1.** Libraries SHOULD return a single table at the end of the file. Returning a single function is acceptable, but not recommended for consistency sake.

**2.2.2.** Libraries SHOULD define the returned table at the beginning, filling in the table throughout the file.

**2.2.3.** Libraries SHOULD NOT make local variables for functions that will be in the returned table. Functions SHOULD be defined directly in the table, like `function library.foo()`.

## 2.3. Program Style
**2.3.1.** Programs SHOULD NOT use any global/environment variables in their code for any reason.

**2.3.2.** Programs that can take command-line arguments SHOULD have a usage prompt when invalid arguments are passed.
