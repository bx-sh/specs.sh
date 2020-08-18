# 🔬 Simple Shell Specifications

<table>
  <thead>
    <th>xUnit-style</th>
    <th>BDD-style</th>
  </thead>
  <tr>
    <td>
      <pre lang="sh">source "my-code.sh"
<br />
setUp() {
  filename="test-file"
  directory="$( mktemp -d )"
}
<br />
tearDown() {
  rm -r "$directory"
}
<br />
testAddFile() {
  assert [ ! -f "$directory/$filename" ]
<br />
  # my code here (e.g. creates a file)
  DIR="$directory" myFunction --writeFile "$filename"
<br />
  assert [ ! -f "$directory/$filename" ]
}<pre>
    </td>
    <td>
      <pre lang="sh">source "my-code.sh"
<br />
@before() {
  filename="test-file"
  directory="$( mktemp -d )"
}
<br />
@after() {
  rm -r "$directory"
}
<br />
@spec.can_add_file() {
  expect { ls "$directory" } not toContain "$filename"
<br />
  # my code here (e.g. creates a file)
  DIR="$directory" myFunction --writeFile "$filename"
<br />
   expect { ls "$directory" } toContain "$filename"
}<pre>
    </td>
  </tr>
</table>