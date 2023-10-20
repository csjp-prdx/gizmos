import json
import subprocess
from collections import defaultdict
from datetime import datetime, timezone

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import Color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
from kitty.utils import color_as_int

timer_id = None

ICON = " ▷ "  # ICON = "  "
RIGHT_MARGIN = 0
REFRESH_TIME = 15

icon_fg = as_rgb(color_as_int(Color(255, 250, 205)))
icon_bg = as_rgb(color_as_int(Color(47, 61, 68)))
# OR icon_bg = as_rgb(0x2f3d44)
bat_text_color = as_rgb(0x999F93)
clock_color = as_rgb(0xDDE4F2)
sep_color = as_rgb(0x999F93)
utc_color = as_rgb(0xF1DDF1)


# cells = [
#     (Color(135, 192, 149), clock),
#     (Color(113, 115, 116), utc),
# ]


# def calc_draw_spaces(*args) -> int:
#     length = 0
#     for i in args:
#         if not isinstance(i, str):
#             i = str(i)
#         length += len(i)
#     return length


def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return 0

    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = icon_fg
    screen.cursor.bg = icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.cursor.x = len(ICON)

    return screen.cursor.x


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    draw_title(draw_data, screen, tab, index)

    trailing_spaces = min(max_title_length - 2, draw_data.trailing_spaces)
    max_title_length -= trailing_spaces
    extra = screen.cursor.x - before - max_title_length

    if extra > 0:
        screen.cursor.x -= extra + 2
        screen.draw("… ")

    end = screen.cursor.x

    return end


def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return 0

    clock = datetime.now().strftime(" %-I:%M ")
    utc = datetime.now(timezone.utc).strftime(" (UTC %H:%M) ")

    cells = []

    cells.append((clock_color, clock))
    cells.append((utc_color, utc))

    right_status_length = RIGHT_MARGIN

    for cell in cells:
        right_status_length += len(str(cell[1]))

    # Put the _right_status on the right side of the sreen
    draw_spaces = screen.columns - screen.cursor.x - right_status_length

    # * Save the current background color
    _fg, _bg = screen.cursor.fg, screen.cursor.bg

    screen.cursor.bg = min(screen.cursor.fg, screen.cursor.bg)

    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)
    # --

    screen.cursor.fg = screen.cursor.bg

    # Draw each cell with its defined background color
    for color, status in cells:
        screen.cursor.bg = color
        screen.draw(status)

    # * Reset the background color
    screen.cursor.fg, screen.cursor.bg = _fg, _bg
    # --

    if screen.columns - screen.cursor.x > right_status_length:
        screen.cursor.x = screen.columns - right_status_length

    return screen.cursor.x


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # _draw_icon(screen, index)
    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    _draw_right_status(
        screen,
        is_last,
    )

    return screen.cursor.x
