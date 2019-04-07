# Aptly Automation
- One of the lessons I've learned about using [aptly](https://www.aptly.info/) effectively is that operators should not be touching their aptly server directly.
- Micromanaging mirrors, repositories, and snapshots for multiple environments gets out of hand really quickly.
- This is a collection of shell scripts that I use automate some of the more tedious tasks involving aptly.


# lessons learned

- use something other than (-) as a delimiter, to separate the values of your names of mirrors,snapshots, and published snapshots. 
- use epoch time, instead of a YYYY-MM-DD format.

