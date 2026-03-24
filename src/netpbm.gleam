import gleam/bit_array
import gleam/int

/// Build a PBM image by iterating over each pixel.
///
/// The callback gets the X and Y position of the pixel, where 0,0 is
/// top-left.
///
/// Rendering starts at the top and goes over each row, left to right, top to
/// bottom.
///
pub fn simple_render_pbm(
  width width: Int,
  height height: Int,
  pixel plot: fn(Int, Int) -> BlackOrWhite,
) -> BitArray {
  render_pbm(width, height, Nil, fn(nil, x, y) { #(nil, plot(x, y)) }).1
}

pub type BlackOrWhite {
  Black
  White
}

/// Build a PBM image by iterating over each pixel with some state.
///
/// The callback gets the X and Y position of the pixel, where 0,0 is
/// top-left.
///
/// Rendering starts at the top and goes over each row, left to right, top to
/// bottom.
///
pub fn render_pbm(
  width width: Int,
  height height: Int,
  state state: state,
  pixel plot: fn(state, Int, Int) -> #(state, BlackOrWhite),
) -> #(state, BitArray) {
  <<"P4 ", int.to_string(width):utf8, " ", int.to_string(height):utf8, " ">>
  |> pbm_loop(width, height, 0, 0, state, plot)
}

fn pbm_loop(
  pbm: BitArray,
  width: Int,
  height: Int,
  x: Int,
  y: Int,
  state: state,
  render: fn(state, Int, Int) -> #(state, BlackOrWhite),
) -> #(state, BitArray) {
  let #(state, pixel) = render(state, x, y)
  let pbm = case pixel {
    White -> <<pbm:bits, 0:size(1)>>
    Black -> <<pbm:bits, 1:size(1)>>
  }
  let x = { x + 1 } % width
  case x {
    0 if y == height - 1 -> #(state, pad_to_bytes(pbm))
    0 -> pad_to_bytes(pbm) |> pbm_loop(width, height, 0, y + 1, state, render)
    _ -> pbm_loop(pbm, width, height, x, y, state, render)
  }
}

/// Build a PGM image by iterating over each pixel.
///
/// 0 is black, 255 is white. Values outside this range are truncated.
///
/// The callback gets the X and Y position of the pixel, where 0,0 is
/// top-left.
///
/// Rendering starts at the top and goes over each row, left to right, top to
/// bottom.
///
pub fn simple_render_pgm(
  width width: Int,
  height height: Int,
  pixel plot: fn(Int, Int) -> Int,
) -> BitArray {
  render_pgm(width, height, Nil, fn(nil, x, y) { #(nil, plot(x, y)) }).1
}

/// Build a PGM image by iterating over each pixel with some state.
///
/// 0 is black, 255 is white. Values outside this range are truncated.
///
/// The callback gets the X and Y position of the pixel, where 0,0 is
/// top-left.
///
/// Rendering starts at the top and goes over each row, left to right, top to
/// bottom.
///
pub fn render_pgm(
  width width: Int,
  height height: Int,
  state state: state,
  pixel plot: fn(state, Int, Int) -> #(state, Int),
) -> #(state, BitArray) {
  <<"P5 ", int.to_string(width):utf8, " ", int.to_string(height):utf8, " 255 ">>
  |> pgm_loop(width, height, 0, 0, state, plot)
}

fn pgm_loop(
  pbm: BitArray,
  width: Int,
  height: Int,
  x: Int,
  y: Int,
  state: state,
  render: fn(state, Int, Int) -> #(state, Int),
) -> #(state, BitArray) {
  let #(state, pixel) = render(state, x, y)
  let pgm = <<pbm:bits, pixel:size(8)>>
  let x = { x + 1 } % width
  case x {
    0 if y == height - 1 -> #(state, pgm)
    0 -> pgm_loop(pgm, width, height, 0, y + 1, state, render)
    _ -> pgm_loop(pgm, width, height, x, y, state, render)
  }
}

fn pad_to_bytes(pbm: BitArray) -> BitArray {
  let remaining = { 8 - bit_array.bit_size(pbm) % 8 } % 8
  <<pbm:bits, 0:size(remaining)>>
}
