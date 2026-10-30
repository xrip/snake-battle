#!/usr/bin/env python3
"""Build the standalone Russian HTML report from the project's Markdown docs.

Requires Markdown 3.7. The report embeds its only image and uses no JavaScript,
web fonts, remote images or network dependencies at reading time.
"""
from pathlib import Path
import argparse
import base64
import html
import json
import posixpath
import re
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
PARTS = [
    ('overview', 'Результат и сборка', 'README.md'),
    ('exact-build', 'Полная нативная пересборка', 'full/build/EXACT_BASELINE.md'),
    ('snk-rec', 'Профили SNK и записи REC', 'docs/SNK_REC.md'),
    ('gpf', 'GPF, графика, музыка и текст', 'docs/GPF_RESOURCES.md'),
    ('drivers', 'Драйвер графики и LZSS', 'docs/DRIVER_INTERNALS.md'),
    ('midi', 'MIDI, SysEx и AdLib', 'docs/MIDI_INTERNALS.md'),
    ('mz', 'EXE: образ и релокации', 'docs/MZ_IMAGE.md'),
    ('architecture', 'Архитектура игры', 'docs/ARCHITECTURE.md'),
    ('compiler', 'Компилятор и CRT', 'docs/COMPILER_CRT.md'),
    ('sound-status', 'Граница восстановления C звука', 'docs/SOUND_REBUILD_STATUS.md'),
    ('adlib-c', 'C AdLib: все 52 процедуры', 'docs/ADLIB_C_STATUS.md'),
    ('midi-c', 'Проверка C MIDI', 'full/sound/midi_c_build/README.md'),
    ('sound-evidence', 'Доказательства по звуковому коду', 'full/sound/exact/PROVENANCE.md'),
    ('provenance', 'Источники и доказательства', 'docs/PROVENANCE.md'),
]

STYLE = '''
:root{color-scheme:light;--ink:#172c35;--muted:#52666e;--accent:#087d7a;--line:#d9e3e5;--paper:#fff;--wash:#f0f5f5}
*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:var(--wash);color:var(--ink);font:16px/1.65 system-ui,-apple-system,"Segoe UI",sans-serif}
a{color:#006b79;text-underline-offset:3px}nav{position:fixed;inset:0 auto 0 0;width:245px;background:#172c35;color:#e8f3f2;padding:30px 22px;overflow:auto}
nav .brand{font-weight:800;letter-spacing:.02em;font-size:20px;margin-bottom:6px}nav .subtitle{font-size:13px;color:#a8c4c7;margin-bottom:28px}nav a{display:block;color:#e6f0f0;text-decoration:none;padding:10px 0;border-bottom:1px solid #35515a;font-size:14px}nav a:hover{color:#8ee4d4}nav .fine{font-size:12px;color:#a8c4c7;margin-top:28px}
main{margin-left:245px;max-width:1345px;padding:38px 48px 70px}header,section,footer{background:var(--paper);padding:32px 38px;margin-bottom:24px;border:1px solid var(--line);border-radius:12px;min-width:0}
h1,h2,h3,h4{line-height:1.28;scroll-margin-top:24px}header h1{font-size:42px;letter-spacing:-.035em;margin:10px 0 18px}h1{font-size:31px}h2{font-size:25px;margin-top:2em;border-bottom:1px solid var(--line);padding-bottom:10px}h3{font-size:20px;margin-top:1.8em}h4{font-size:17px}p{margin:.8em 0}strong{font-weight:700}.eyebrow{font-size:12px;text-transform:uppercase;letter-spacing:.12em;color:var(--accent);font-weight:800}
.scope{background:#fff6dc;border-left:4px solid #b68920;padding:14px 18px;border-radius:4px;margin:22px 0}.scope strong{color:#755200}.stats{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:22px 0}.stat{padding:17px;background:#edf7f5;border-radius:8px}.stat b{display:block;font-size:27px;color:#066d69}.stat span{font-size:13px;color:var(--muted)}figure{margin:24px 0 0}figure img{width:100%;height:auto;display:block;border-radius:6px}figcaption{font-size:12px;color:var(--muted);margin-top:9px}
.section-label{font-size:12px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:var(--accent);margin-bottom:18px}ul,ol{padding-left:24px}li{margin:5px 0}table{border-collapse:collapse;width:100%;font-size:13px;line-height:1.5;margin:20px 0;overflow-wrap:anywhere}th,td{padding:10px 12px;border:1px solid var(--line);text-align:left;vertical-align:top}th{background:#e9f2f2;font-weight:700}tr:nth-child(even) td{background:#f8fafb}pre{background:#13282f;color:#e3f4ef;padding:18px 20px;border-radius:8px;overflow:auto;line-height:1.5;font-size:12px}code{font: .88em/1.5 ui-monospace,SFMono-Regular,Consolas,monospace;overflow-wrap:anywhere}p code,li code,td code{background:#edf2f4;padding:1px 4px;border-radius:3px}pre code{font-size:inherit;white-space:pre;overflow-wrap:normal}blockquote{margin:20px 0;padding:5px 20px;border-left:4px solid #99babc;color:var(--muted)}.archive-path{border-bottom:1px dotted #a3b8bb}.toc{font-size:14px}.footer-note{font-size:14px;color:var(--muted)}
@media(max-width:1000px){nav{position:static;width:auto;padding:20px}nav a{display:inline-block;margin-right:20px;border:0;padding:5px 0}nav .subtitle,nav .fine{display:none}main{margin:0;padding:18px}header,section,footer{padding:22px}header h1{font-size:32px}table{font-size:12px}th,td{padding:7px}.stats{gap:7px}.stat{padding:12px}}
@media print{nav{display:none}body{background:#fff;font-size:10pt}main{margin:0;padding:0;max-width:none}header,section,footer{padding:0;border:0;box-shadow:none}section{break-before:page}table{font-size:8pt}tr,figure,.scope,.stat{break-inside:avoid}pre{white-space:pre-wrap;color:#172c35;background:#f1f4f4}h1,h2,h3,h4{break-after:avoid}a{color:inherit;text-decoration:none}}
'''


def main():
    import markdown
    from markdown.extensions.toc import slugify_unicode
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    proof = json.loads((ROOT/'full/build/exact/comparison.json').read_text())
    if not (proof['file_byte_exact'] and proof['mz_header_exact'] and
            proof['relocation_representation_and_order_exact']):
        raise SystemExit('The current report requires a verified whole-file exact build')
    destinations = {path: key for key, _, path in PARTS}
    sections = []
    for number, (key, label, path) in enumerate(PARTS, 1):
        text = (ROOT/path).read_text()
        md = markdown.Markdown(extensions=['tables','fenced_code','sane_lists','toc'],
                               extension_configs={'toc':{'slugify':
                                   lambda value, separator, key=key: key+'-'+slugify_unicode(value, separator)}})
        body = md.convert(text)
        def link(match):
            target, content = html.unescape(match.group(1)), match.group(2)
            parsed = urlsplit(target)
            if parsed.scheme or parsed.netloc:
                return match.group(0)
            destination = (posixpath.normpath(posixpath.join(
                posixpath.dirname(path), unquote(parsed.path)))
                if parsed.path else path)
            if destination in destinations:
                anchor = destinations[destination]
                if parsed.fragment:
                    anchor += '-' + unquote(parsed.fragment)
                return f'<a href="#{html.escape(anchor, quote=True)}">{content}</a>'
            return f'<span class="archive-path" title="Путь в проекте: {html.escape(destination, quote=True)}">{content}</span>'
        body = re.sub(r'<a href="([^"]+)">(.*?)</a>', link, body, flags=re.S)
        sections.append(f'<section id="{key}"><div class="section-label">Раздел {number} · {label}</div>{body}</section>')
    picture = base64.b64encode((ROOT/'assets/png/screens-overview.png').read_bytes()).decode('ascii')
    navigation = ''.join(f'<a href="#{key}">{number:02d} · {label}</a>'
                         for number,(key,label,_) in enumerate(PARTS,1))
    document = f'''<!doctype html>
<html lang="ru"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Snake Battle — полная побайтовая пересборка EXE и форматы файлов</title><style>{STYLE}</style></head>
<body><nav aria-label="Содержание"><div class="brand">Snake Battle</div><div class="subtitle">C и ASM · оригинальный Borland · форматы</div>{navigation}<div class="fine">Технический отчёт по предоставленной поставке.<br>21 октября 2026.</div></nav><main>
<header><div class="eyebrow">Реверс-инжиниринг · проверяемые результаты</div><h1>Полная побайтовая пересборка EXE<br>и внутренние форматы</h1><p>Весь DOS-файл <code>SNAKE.EXE</code> заново получен из восстановленных исходников C и ASM, оригинальной CRT Borland и нативного линкера. Прямое сравнение готовых файлов подтверждает ноль отличий, включая MZ-заголовок и порядок релокаций.</p>
<div class="scope"><strong>Полный byte-exact EXE получен смешанной сборкой C + ASM.</strong> Основные C-модули компилируются оригинальными Borland C++ 3.1 и 2.0. Звуковой блок имеет точное символическое ASM-представление и отдельные читаемые C-кандидаты; полное совпадение его компиляции из C пока не достигнуто. Это ограничение не скрывается за общим хешем EXE.</div>
<div class="stats"><div class="stat"><b>{proof['built']['size']:,} байт</b><span>весь файл совпадает; различающихся байт — {proof['differing_file_bytes']}</span></div><div class="stat"><b>{proof['built']['fields']['relocations']} релокаций</b><span>совпадают записи, их представление и порядок</span></div><div class="stat"><b>24 C-модуля</b><span>плюс 3 ASM-модуля и 92 оригинальных CRT-объекта</span></div></div>
<p><strong>Общий SHA-256:</strong> <code>{proof['built']['sha256']}</code></p>
<figure><img alt="Четыре полноэкранных ресурса, извлечённые из SNAKE.GPF" src="data:image/png;base64,{picture}"><figcaption>Извлечённые ресурсы PLAN1, PLAN3, PLAN2 и RPLAN2. Это декодированные данные исходного GPF; полный графический сеанс пересобранной игры не заявляется.</figcaption></figure></header>
{''.join(sections)}
<footer id="archive"><h2>Файлы для воспроизведения</h2><p>Восстановленные C и ASM, Python-сборщики и парсеры, неизменённая исходная поставка, извлечённые ресурсы, итоговый EXE, MAP/OBJ, журналы и машинные доказательства находятся в архиве <code>snake-battle-recovered.zip</code>. Пути в этом отчёте относятся к каталогу проекта внутри архива. Исполняемые файлы самих исторических компиляторов не включены; их версии, источники и контрольные суммы указаны в проекте.</p><p class="footer-note">HTML содержит основные главы документации и встроенное изображение. Для чтения не требуется доступ к сети. Полные проверочные JSON и вспомогательные документы находятся в архиве.</p></footer>
</main></body></html>'''
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(document)
    print(f'{args.output}: {args.output.stat().st_size} bytes, {len(PARTS)} sections')


if __name__ == '__main__':
    main()
