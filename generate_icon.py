"""Generate futureBank app icon — deep blue/gold gradient with FB monogram."""

from PIL import Image, ImageDraw, ImageFont
import os, math

SIZES = {
    'android/mipmap-mdpi': 48,
    'android/mipmap-hdpi': 72,
    'android/mipmap-xhdpi': 96,
    'android/mipmap-xxhdpi': 144,
    'android/mipmap-xxxhdpi': 192,
    'ios/Icon-App-20x20@1x': 20,
    'ios/Icon-App-20x20@2x': 40,
    'ios/Icon-App-20x20@3x': 60,
    'ios/Icon-App-29x29@1x': 29,
    'ios/Icon-App-29x29@2x': 58,
    'ios/Icon-App-29x29@3x': 87,
    'ios/Icon-App-40x40@1x': 40,
    'ios/Icon-App-40x40@2x': 80,
    'ios/Icon-App-40x40@3x': 120,
    'ios/Icon-App-60x60@2x': 120,
    'ios/Icon-App-60x60@3x': 180,
    'ios/Icon-App-76x76@1x': 76,
    'ios/Icon-App-76x76@2x': 152,
    'ios/Icon-App-83.5x83.5@2x': 167,
    'ios/Icon-App-1024x1024@1x': 1024,
}

OUTPUT = 'assets/app_icon'


def make_icon(size):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Brand colors: deep blue → electric blue gradient
    top_color = (13, 47, 110)    # #0D2F6E primary700
    bot_color = (26, 86, 219)    # #1A56DB primary500
    gold = (212, 160, 23)        # #D4A017 gold500
    white = (255, 255, 255, 255)

    r = size // 2
    cx = cy = r

    # Rounded rectangle background (not circle — more modern)
    corner = size * 0.22
    for y in range(size):
        for x in range(size):
            # Check if inside rounded rect
            dx = max(corner - x, 0, x - (size - corner))
            dy = max(corner - y, 0, y - (size - corner))
            if dx*dx + dy*dy <= corner*corner:
                t = y / size
                cr = int(top_color[0] * (1-t) + bot_color[0] * t)
                cg = int(top_color[1] * (1-t) + bot_color[1] * t)
                cb = int(top_color[2] * (1-t) + bot_color[2] * t)
                img.putpixel((x, y), (cr, cg, cb, 255))

    # Gold accent bar at bottom 20%
    bar_h = int(size * 0.18)
    bar_y = size - bar_h
    for y in range(bar_y, size):
        for x in range(size):
            if img.getpixel((x, y))[3] > 0:
                t = (y - bar_y) / bar_h
                cr = int(bot_color[0] * (1-t) + gold[0] * t)
                cg = int(bot_color[1] * (1-t) + gold[1] * t)
                cb = int(bot_color[2] * (1-t) + gold[2] * t)
                img.putpixel((x, y), (cr, cg, cb, 255))

    # Draw "FB" text centered
    font_size = int(size * 0.42)
    try:
        font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', font_size)
    except:
        font = ImageFont.load_default()

    text = 'FB'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    tx = (size - tw) // 2 - bbox[0]
    ty = (size - th) // 2 - bbox[1] - int(size * 0.05)
    draw.text((tx, ty), text, font=font, fill=white)

    # Small gold dot under text (brand detail)
    dot_r = max(2, size // 28)
    dot_x, dot_y = cx, ty + th + int(size * 0.05)
    draw.ellipse([(dot_x - dot_r, dot_y - dot_r), (dot_x + dot_r, dot_y + dot_r)],
                 fill=gold)

    return img


def main():
    base = os.path.join(os.path.dirname(__file__), OUTPUT)
    for label, px in SIZES.items():
        img = make_icon(px)
        if 'android' in label:
            fname = f'ic_launcher_{px}.png'
        else:
            fname = os.path.basename(label) + '.png'
        dir_path = os.path.join(base, os.path.dirname(label))
        os.makedirs(dir_path, exist_ok=True)
        path = os.path.join(dir_path, fname)
        img.save(path)
        print(f'  {px}x{px}  →  {os.path.relpath(path)}')
    store_path = os.path.join(base, 'store_icon_1024.png')
    make_icon(1024).save(store_path)
    print(f'\nDone! Icons in {OUTPUT}/')


if __name__ == '__main__':
    main()
