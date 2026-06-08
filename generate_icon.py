"""
futureBank app icon generator.
Design: Dark navy background, stylized 'f' lettermark with a gold upward arrow
integrated into the stem — communicates finance + growth.
"""

from PIL import Image, ImageDraw
import os
import math

ANDROID_SIZES = {
    'mipmap-mdpi':    48,
    'mipmap-hdpi':    72,
    'mipmap-xhdpi':   96,
    'mipmap-xxhdpi':  144,
    'mipmap-xxxhdpi': 192,
}

IOS_SIZES = {
    'Icon-App-20x20@1x':      20,
    'Icon-App-20x20@2x':      40,
    'Icon-App-20x20@3x':      60,
    'Icon-App-29x29@1x':      29,
    'Icon-App-29x29@2x':      58,
    'Icon-App-29x29@3x':      87,
    'Icon-App-40x40@1x':      40,
    'Icon-App-40x40@2x':      80,
    'Icon-App-40x40@3x':      120,
    'Icon-App-60x60@2x':      120,
    'Icon-App-60x60@3x':      180,
    'Icon-App-76x76@1x':      76,
    'Icon-App-76x76@2x':      152,
    'Icon-App-83.5x83.5@2x':  167,
    'Icon-App-1024x1024@1x':  1024,
}

# Brand colors
NAVY       = (10, 22, 40)      # #0A1628 — deep background
BLUE       = (26, 86, 219)     # #1A56DB — primary
BLUE_MID   = (13, 47, 110)     # #0D2F6E
GOLD       = (212, 160, 23)    # #D4A017
WHITE      = (255, 255, 255)


def lerp_color(c1, c2, t):
    return tuple(int(c1[i] * (1 - t) + c2[i] * t) for i in range(3))


def make_icon(size: int) -> Image.Image:
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # --- Background: rounded rectangle with radial gradient feel ---
    radius = size * 0.22
    # Draw rounded rect pixel by pixel for smooth gradient
    for y in range(size):
        for x in range(size):
            # Rounded rect mask
            cx = max(radius, min(x, size - radius))
            cy = max(radius, min(y, size - radius))
            dist = math.sqrt((x - cx) ** 2 + (y - cy) ** 2)
            if dist > radius:
                continue
            # Diagonal gradient: top-left = BLUE_MID, bottom-right = NAVY
            t = (x + y) / (size * 2)
            color = lerp_color(BLUE_MID, NAVY, t)
            img.putpixel((x, y), (*color, 255))

    # --- Subtle grid lines (fintech feel) ---
    grid_color = (*lerp_color(BLUE_MID, BLUE, 0.3), 30)
    grid_step = size // 8
    for i in range(1, 8):
        x = i * grid_step
        y = i * grid_step
        for px in range(size):
            if 0 <= x < size:
                cur = img.getpixel((x, px))
                if cur[3] > 0:
                    img.putpixel((x, px), (
                        min(255, cur[0] + 15),
                        min(255, cur[1] + 25),
                        min(255, cur[2] + 40),
                        cur[3]
                    ))

    draw = ImageDraw.Draw(img)

    # --- Main mark: stylized lowercase 'f' as geometric shapes ---
    # Built from rectangles — no font dependency, scales perfectly
    pad = size * 0.22
    stroke = size * 0.11

    # Vertical stem
    stem_x = pad
    stem_top = pad
    stem_bot = size - pad
    stem_w = stroke
    draw.rounded_rectangle(
        [stem_x, stem_top, stem_x + stem_w, stem_bot],
        radius=stroke * 0.5,
        fill=WHITE
    )

    # Top horizontal bar (the 'f' crossbar at top)
    bar_top_y = stem_top + stroke * 0.3
    bar_top_x2 = pad + stroke * 3.2
    draw.rounded_rectangle(
        [stem_x, bar_top_y, bar_top_x2, bar_top_y + stroke],
        radius=stroke * 0.5,
        fill=WHITE
    )

    # Middle crossbar
    mid_y = size * 0.5 - stroke * 0.5
    mid_x2 = pad + stroke * 2.6
    draw.rounded_rectangle(
        [stem_x, mid_y, mid_x2, mid_y + stroke],
        radius=stroke * 0.5,
        fill=WHITE
    )

    # --- Gold upward arrow on the right side ---
    arrow_cx = size * 0.72
    arrow_tip_y = size * 0.25
    arrow_base_y = size * 0.72
    arrow_w = size * 0.13

    # Arrow shaft
    shaft_x = arrow_cx - arrow_w * 0.4
    draw.rounded_rectangle(
        [shaft_x, arrow_tip_y + arrow_w * 1.2,
         shaft_x + arrow_w * 0.8, arrow_base_y],
        radius=arrow_w * 0.3,
        fill=GOLD
    )

    # Arrow head (triangle)
    head_w = arrow_w * 1.6
    draw.polygon([
        (arrow_cx, arrow_tip_y),
        (arrow_cx - head_w, arrow_tip_y + head_w * 1.1),
        (arrow_cx + head_w, arrow_tip_y + head_w * 1.1),
    ], fill=GOLD)

    # --- Gold dot accent bottom ---
    dot_r = max(2, int(size * 0.035))
    dot_x = int(arrow_cx)
    dot_y = int(arrow_base_y + size * 0.06)
    draw.ellipse(
        [dot_x - dot_r, dot_y - dot_r, dot_x + dot_r, dot_y + dot_r],
        fill=GOLD
    )

    return img


def save_android(img: Image.Image, folder: str, size: int):
    path = os.path.join(
        'android', 'app', 'src', 'main', 'res', folder, 'ic_launcher.png'
    )
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.resize((size, size), Image.LANCZOS).save(path)
    print(f'  ✓ {path}')


def save_ios(img: Image.Image, name: str, size: int):
    path = os.path.join(
        'ios', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset', f'{name}.png'
    )
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.resize((size, size), Image.LANCZOS).save(path)
    print(f'  ✓ {path}')


def main():
    print('Generating futureBank icons...\n')
    master = make_icon(1024)

    print('Android:')
    for folder, size in ANDROID_SIZES.items():
        save_android(master, folder, size)

    print('\niOS:')
    for name, size in IOS_SIZES.items():
        save_ios(master, name, size)

    master.save('store_icon_1024.png')
    print('\n✅ Done. store_icon_1024.png saved for Play Store / App Store.')


if __name__ == '__main__':
    main()
