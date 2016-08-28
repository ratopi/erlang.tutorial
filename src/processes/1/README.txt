Lets test it in erlang shell:

1> c(test).
{ok,test}

Creating parent process with initial state first_state

2> ParentPid = spawn( test, loop, [ first_state ] ).
<0.38.0>
3> test:get_state( ParentPid ).
{curr_state,first_state}
4>

Lets change state of parent process to second_state:

4> test:change_state( ParentPid, second_state ).
{{old_state,first_state},{new_state,second_state}}

Fork new process from parent process:

5> ChildPid = test:fork( ParentPid ).
<0.42.0>

Check state of forked process (it is the same as in parent process):

6> test:get_state( ChildPid ).
{curr_state,second_state}
