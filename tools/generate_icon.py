import os
from PIL import Image, ImageDraw, ImageFont

COLOR_BG_TOP = (10, 22, 40)
COLOR_BG_BOT = (13, 47, 110)
COLOR_ACCENT = (212, 160, 23)
COLOR_WHITE = (255, 255, 255)
OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'android', 'app', 'src', 'main', 'res')

SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

def make_icon(size):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    padding = size * 0.08
    r = size * 0.18

    for y in range(size):
        t = y / size
        r_val = int(COLOR_BG_TOP[0] + (COLOR_BG_BOT[0] - COLOR_BG_TOP[0]) * t)
        g_val = int(COLOR_BG_TOP[1] + (COLOR_BG_BOT[1] - COLOR_BG_TOP[1]) * t)
        b_val = int(COLOR_BG_TOP[2] + (COLOR_BG_BOT[2] - COLOR_BG_TOP[2]) * t)
        draw.line([(padding, y), (size - padding, y)], fill=(r_val, g_val, b_val))

    draw.rounded_rectangle(
        [padding, padding, size - padding, size - padding],
        radius=r, fill=None, outline=COLOR_ACCENT, width=max(2, size // 48)
    )

    fs = size // 4
    first = True
    for try_size in range(fs, size // 8, -2):
        try:
            font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', try_size)
            font2 = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', int(try_size * 0.7))
            first = False
            break
        except OSError:
            continue
    if first:
        font = ImageFont.load_default()

    text = 'fB'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = (size - tw) / 2
    ty = (size - th) / 2 - size * 0.02
    draw.text((tx, ty), text, fill=COLOR_ACCENT, font=font)
    return img

def main():
    for folder, size in SIZES.items():
        out = os.path.join(OUT_DIR, folder)
        os.makedirs(out, exist_ok=True)
        img = make_icon(size)
        path = os.path.join(out, 'ic_launcher.png')
        img.save(path)
        print(f'  {path}  ({size}x{size})')
    print('Done — all icons generated.')

if __name__ == '__main__':
    main()
