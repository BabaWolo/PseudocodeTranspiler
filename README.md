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
Open the project in your preferred text editor, e.g. VS Code, and expand the folder *lib*. Navigate to the file *test.txt* and provide the pseudo code that you'd like to have translated. In the editor open a new terminal and type `dune build`. This will compile the Ocaml project and generate the corresponding executable file. In the same terminal, change the current directory using the command `cd bin`. Now you can either translate your source code to Python using the command `dune exec ../main.exe python` or translate it to JavaScript using `dune exec ../main.exe JavaScript`. If you have followed the steps correctly, your terminal should look something like this

```
$ myUser pseudocode % dune build
$ myUser pseudocode % cd bin
$ myUser bin % dune exec ../main.exe python
  Entering directory '../../pseudocode'
  Leaving directory '../../pseudocode'
```
The above translates the source code to Python by creating a new file *output.py*. In VS Code you can run it by navigating to the file and clicking on the **run button** or by opening a new terminal and using the command `Python output.py`. This will display your code in Python in your terminal.

## Quick Guide
1. Clone repository `git clone https://github.com/SW4-G3-AAU/pseudocode.git`
2. In the text editor, open the folder *lib* and insert your pseudo code in to the file *test.txt*
3. Open a new terminal and run `dune build`
4. In the same terminal, change directory using `cd bin`
5. To translate code to Python run `dune exec ../main.exe python`, and to translate code to Java run `dune exec ../main.exe java` (TO BE UPDATED)
7. Depending on the selected language, either an *output.py* or *output.java* file will be created with the translated source code (TO BE UPDATED). Run the file by hitting the **run button** or by using `Python output.py` in a new terminal.

<br>

<h2 align="center">Syntax:</h2>
<h4>Variables:</h4>
<ul>
  <li>Any string beginning with a character a-z | A-Z</li>
</ul>

<h4>Assignment:</h4>
<ul>
  <li>=</li>
</ul>

<h4>Booleans:</h4>
<ul>
  <li>true</li>
  <li>false</li>
</ul>

<h4>Logical Operators:</h4>
<ul>
  <li>not</li>
  <li>!=</li>
  <li>==</li>
  <li>&lt;</li>
  <li>&gt;</li>
  <li>&lt;=</li>
  <li>&gt;=</li>
</ul>

<h4>Binary Operations:</h4>
<ul>
  <li>+</li>
  <li>-</li>
  <li>*</li>
  <li>/</li>
  <li>floor()</li>
  <li>ceiling()</li>
</ul>

<h4>Unary Operations:</h4>
<ul>
  <li></li>
</ul>

<h4>Iterative Statements:</h4>
<ul>
  <!-- Insert iterative statements here -->
</ul>

<h4>Collections:</h4>
<ul>
  <!-- Insert collections here -->
</ul>

<h4>Other Datastructures:</h4>
<ul>
  <!-- Insert other datastructures here -->
</ul>

<h4>Methods:</h4>
<ul>
  <!-- Insert methods here -->
</ul>

<h4>Additional characters:</h4>
<ul>
  <!-- Insert additional characters here -->
</ul>
