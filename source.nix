# The skill source's upstream owner, imported as the `source` argument to
# flake-skills' builders so package keys are namespaced as
# `agent-skill-<owner>-<name>`. A flake can't read its own `github:owner/repo`
# off `self`, so the owner is stated rather than derived.
{ owner = "nhooey"; }
