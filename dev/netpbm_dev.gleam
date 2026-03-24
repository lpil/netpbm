import netpbm
import simplifile

pub fn main() {
  let pbm =
    netpbm.render_pbm(width: 30, height: 20, state: Nil, pixel: fn(s, x, y) {
      let pixel = case x % 3 == 0 && y % 2 == 0 {
        True -> netpbm.Black
        False -> netpbm.White
      }
      #(s, pixel)
    }).1
  let assert Ok(_) = simplifile.write_bits("out.pbm", pbm)

  let pbm =
    netpbm.simple_render_pbm(width: 30, height: 20, pixel: fn(x, y) {
      case x % 3 == 0 && y % 2 == 0 {
        True -> netpbm.Black
        False -> netpbm.White
      }
    })
  let assert Ok(_) = simplifile.write_bits("out2.pbm", pbm)

  let pgm =
    netpbm.render_pgm(width: 510, height: 255, state: Nil, pixel: fn(s, x, y) {
      let pixel = { x / 2 + y } / 2
      #(s, pixel)
    }).1
  let assert Ok(_) = simplifile.write_bits("out.pgm", pgm)

  let pgm =
    netpbm.simple_render_pgm(width: 510, height: 255, pixel: fn(x, y) {
      // Render a gradiant from top-left to bottom-right
      { x / 2 + y } / 2
    })
  let assert Ok(_) = simplifile.write_bits("out2.pgm", pgm)
}
