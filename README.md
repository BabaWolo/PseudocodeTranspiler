<p align="center">
  <img src="https://blog.campaignmaster.co.uk/wp-content/uploads/2019/05/giphy.gif" alt="MasterHead" width="500" height="266">
</p>

<h1 align="center">PseudoCode Compiler (PCC)</h1>

<h3 align="center">A 4. semester project by 
<br> <br>
<i>Frederik Rasmussen Woloszynski, Luca Allan Purcilly, Nicolas Øbakke <br>
Donald Brinch, Alexander Svensson, and Mads Aaen Westh-Jensen</i> </h3>
<br>

<div align="center">
  <img src="https://github.com/SW4-G3-AAU/pseudocode/assets/116066516/5a8369b8-9147-4616-b675-ec9b289f0e4c" alt="smoky-neon-glow-text-effect-tutorial-removebg-preview" style="max-width: 100%;">
</div>

## Prerequisites
You should have at least Python or Java installed on your computer in order to run the program. You can install them by following these simple guides: [Install Python](https://code.visualstudio.com/docs/languages/python) 🐍 or [Install Java](https://code.visualstudio.com/docs/languages/java) ☕️.

<br>

## Walkthrough
On your desktop open a terminal and change the current directory to the location where you want the cloned repository. To clone the repository, type the following
```
git clone https://github.com/SW4-G3-AAU/pseudocode.git
```
Open the project in your preferred text editor, e.g. VS Code, and expand the folder *lib*. Navigate to the file *test.txt* and provide the pseudo code that you'd like to have translated. In the editor open a new terminal and type `make` or `make build_run`. This will compile the program with python as the default target language. If you want another language you can write `make lang=<language>` where `<language>` should be replaced with `python` or `java`.

A new file named *output.py* is generated, containing the source code translated into Python. In VS Code you can run it by navigating to the file and hitting the **run button** or by using the terminal and typing `Python output.py`. Your code is now being displayed in Python within your terminal. If you don't see any output in your terminal, make sure to include print statements into your code.

<br>

## Syntax
This section displays the valid syntax for writing code within our program. It's similar to the conventions outlined in the ALG course but replaces a few elements. The primary alteration is replacing indentation with curly brackets `{}`.

#### Variables, Data Types & Assignment
- Any string that starts with a character a-z or A-Z and can't be the same as a reserved keyword
- Integer, float, string, bool
- =

#### Booleans
- true
- false

#### Logical Operators
- and
- or
- not

#### Relational Operators
- ==
- != *replaces* ≠
- \<=
- \>=
- &lt;
- &gt;

#### Binary Operations
- \+
- \-
- \*
- /
- %

#### Unary Operators
- \+
- \-

#### Control flow
- if <*condition*>
```
number = 10
if number == 5 {
    print("Five")
} elseif number == 10 {
    print("Ten")
} else {
    print("Wrong number")
}
```
- elseif <*condition*>
- else
- return

#### Iterative Statements
- for \<*initialization of guardian variable*> to/downto \<*condition*>
```
Bubblesort(A)
for i = 1 to A.length - 1 {
  for j = A.length downto i + 1 {
    ...
  }
}
```
- while \<*condition*> \<*code*>
```
i = 1
while i < 10 {
  i = i + 1
}
```

- while \<*condition*> do \<*code*>
```
Sum(A, n)
i = 0
sum = 0
while i <= n do {
  sum = sum + A[i]
  break
}
```

- repeat \<*code*> until \<*condition*>
```
x = 0
repeat {
  x = x + 2
} until x == 10
```

- continue
- break

#### Collections, Data Structures & Attributes
- let \<*var*> be a new array
```
let A be a new array
A = [7, 2, 100, -55]
// optionally create a range
let R[1..n + 1] be a new array
```
- let \<*var*> be a new hashtable
- let \<*var*> be a new queue
- let \<*var*> be a new stack
- \<*var*> = newLinkedList([<*elements*>])
- \<*var*> = newBinaryTree
- .length
- .next
- .prev
- .key
- .head
- .left
- .right
- .p
- .root
- .top
- .tail

#### Methods
- floor() *replaces* ⌊⌋
```
floor(3.75)
floor(-23.44)
// output: 3, -24
```

- ceil() *replaces* ⌈⌉
```
ceil(3.14)
ceil(-23.65)
// output: 4, -23
```

- round()
```
round(3.5)
round(-22.64)
// output: 4, -22
```

- exchange \<*var*> with \<*var*>
```
x = 5
y = 10
exchange x with y
// output: x = 10, y = 5
```

- random()
```
random(0, 9)
// output: random number from 0-9 (inclusive)
```

- sort
```
list A = [50, 2, 1, 100, 43]
sort A
// output: [1, 2, 43, 50, 100]
```

- len()
```
list A = [1, 2, 3, 4, 5]
len(A)
// output: 5
```

#### Additional Characters
- Comment `//`
- print()
- infinity
- NIL
- error
```
x = NIL
if x == NIL {
  error "x cannot be nil"
}
```

- ()
- []
- {}
