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

## Comprehensive Guide
On your device open your terminal and change the current directory to the location where you want the cloned repository. To clone the repository, type the following
```
git clone https://github.com/SW4-G3-AAU/pseudocode.git
```
Open the project in your preferred text editor, e.g. VS Code, and expand the folder *lib*. Navigate to the file *test.txt* and provide the pseudo code that you'd like to have translated. Remember to wrap the result within a `print` statement. In the editor open a new terminal and type `dune build`. This will compile the Ocaml project and generate the corresponding executable file. In the same terminal, change the current directory using the command `cd bin`. Now you can either translate your source code to Python using the command `dune exec ../main.exe python` or translate it to Java using `dune exec ../main.exe Java`. If you have followed the steps correctly, your terminal should look something like this

```
$ myUser pseudocode % dune build
$ myUser pseudocode % cd bin
$ myUser bin % dune exec ../main.exe python
  Entering directory '../../pseudocode'
  Leaving directory '../../pseudocode'
```
The above translates the source code to Python by creating a new file *output.py*. In VS Code you can run it by navigating to the file and clicking on the **run button** or by opening a new terminal and using the command `Python output.py`. This will display your code in Python in your terminal.

<br>

## Quick Guide
1. Clone repository `git clone https://github.com/SW4-G3-AAU/pseudocode.git`
2. In the text editor, open the folder *lib* and insert your pseudo code in to the file *test.txt*
3. Open a new terminal and run `dune build`
4. In the same terminal, change directory using `cd bin`
5. To translate code to Python run `dune exec ../main.exe python`, and to translate code to Java run `dune exec ../main.exe java` (TO BE UPDATED)
7. Depending on the selected language, either an *output.py* or *output.java* file will be created with the translated source code (TO BE UPDATED). Run the file by hitting the **run button** or by using `Python output.py` in a new terminal.

<br>

## Syntax
This section displays the valid syntax for writing code within our program. It's similar to the conventions outlined in the ALG course but replaces a few elements. The primary alteration is replacing indentation with curly brackets.

#### Variables, Data Types & Assignment
- Any string that starts with a character a-z or A-Z
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
Sum(A, n)
i = 0
sum = 0
while i <= n do {
  sum = sum + A[i]
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
- let \<*var*> be a new stack
- let \<*var*> be a new queue
- let \<*var*> be a new array
- let \<*var*> be a new hashtable
- length
- next
- prev
- key
- head
- left
- right
- p
- root
- top
- tail

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

- exchange <var> with <var>
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
