1. configuring the "wttrrc" weather conky:

- edit the wttrrc file itself to change the location to your current location.  Note the comment inserted in wttrrc itself - where your location name has more than 1 word, add a "+" between each word instead of a space.


2. configuring the "diskrc" conky to display the percentage of storage space used for a selected disk/partition:

- edit the "diskrc" file to add the name or label under which you are mounting the disk/partition in question.  This is done by replacing references to "LABEL" with the actual label name of the disk/partition, and assumes you have already labelled the disk/partition in question with GParted or another program.


