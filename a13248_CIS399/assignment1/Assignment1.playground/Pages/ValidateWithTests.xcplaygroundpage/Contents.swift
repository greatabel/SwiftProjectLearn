/*:
[Previous](@previous)

# Validate with tests

The assignment includes unit tests to validate the code you are writing. Because the tests depend on code that you will
write as you work on the assignment you will have to enable them as you finish your work (if they were enabled before
you write the code they test, the project would not compile). The tests are split into multiple test bundles; one for
each page of this playground that instruct you to write code (with the exception of the Main page), so as you finish a
page in the playground you can enable the related tests and check your work.

To do this select the "Edit Scheme" option from the "Scheme" sub-menu in the "Product" menu in Xcode. In the dialog
that is shown, select the "Test" action on the left and select the "Info" tab. Click the button near the bottom left of
the dialog with the "+" icon. Select a test bundle corresponding to the page you just finished and then click the "Add"
button. The test bundle should now show up in the list with its Enabled checkbox checked. Once this is done click the
"Close" button to stop editing the scheme.

Once you configured the test phase of the scheme with at least one test bundle, you should be able to select the "Test"
option in the "Product" menu to run the enabled tests and validate the code they exercise. This will compile and run the
unit tests. Note that if you have not finished your implementation or there are inconsistencies between the symbol names
the unit tests are expecting and what you have implemented, the tests will not compile and you will receive errors. The
errors should indicate what symbols are missing to help you track down where the inconsistency is.

Remember to enable the `SportTests` test bundle and run the tests to validate your work.

At this point you have completed part of the imlementation and the related tests should be passing. This is a great time
to make a git commit to capture your work in progress. Use the git client you prefer (the git command line tool, Xcode,
the Sourcetree app, etc.) to commit all your work so far.  Make sure to include a commit message briefly describing the
work being commited.

The next page will describe how to [implement the Triathlon enum](@next).
*/
