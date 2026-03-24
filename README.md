# netpbm

Render PBM and PGM images in Gleam

[![Package Version](https://img.shields.io/hexpm/v/netpbm)](https://hex.pm/packages/netpbm)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/netpbm/)

```sh
gleam add netpbm@1
```
```gleam
import netpbm
import simplifile

pub fn main() -> Nil {
  let pgm =
    netpbm.simple_render_pgm(width: 510, height: 255, pixel: fn(x, y) {
      // Render a gradiant from top-left to bottom-right
      { x / 2 + y } / 2
    })
  let assert Ok(_) = simplifile.write_bits("out2.pgm", pgm)
}
```

Further documentation can be found at <https://hexdocs.pm/netpbm>.
