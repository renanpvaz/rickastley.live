# [rickastley.live](https://rickastley.live)

It's exactly what you think it is:

```bash
$ curl rickastley.live
```

<img src="https://user-images.githubusercontent.com/14297772/112697068-a241e280-8e65-11eb-93f5-e26c17e484ef.png">

## Running with stack

```bash
$ ./mkframes # generate the ascii art
$ stack build
$ PORT=3000 FRAME_SIZE=30 stack run rickastley-exe
# Setting phasers to stun... (port 3000) (ctrl-c to quit)
```
<br>
<hr>

Inspired by [parrot.live](https://github.com/hugomd/parrot.live).
