---
layout: post
category: swing
folder: ColorChooserSwatchSize
title: JColorChooserのSwatchサイズを変更する
tags: [JColorChooser, UIManager]
author: aterai
pubdate: 2020-01-20T14:48:19+09:00
description: JColorChooserのSwatchChooserPanelで使用される各Swatchのサイズを変更します。
image: https://drive.google.com/uc?id=1ZXY57mdtRubzvYCnvj-eoSmfsUvPPmlU
comments: true
---
## 概要
`JColorChooser`の`SwatchChooserPanel`で使用される各`Swatch`のサイズを変更します。

{% download https://drive.google.com/uc?id=1ZXY57mdtRubzvYCnvj-eoSmfsUvPPmlU %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ColorChooser.swatchesRecentSwatchSize", new Dimension(10, 10));
UIManager.put("ColorChooser.swatchesSwatchSize", new Dimension(6, 10));
</code></pre>

## 解説
- `ColorChooser.swatchesRecentSwatchSize`
    - 「最新」`Recent`パレットの`Swatch`サイズを指定
    - `Swatch`のデフォルトサイズは`10*10px`
    - `Swatch`の数は`5*7`で固定
- `ColorChooser.swatchesSwatchSize`
    - パレットの`Swatch`サイズを指定
    - `Swatch`のデフォルトサイズは`10*10px`
    - `Swatch`の数は`31*9`で固定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JColorChooserから指定したColorChooserPanelを削除して表示する](https://ateraimemo.com/Swing/ColorChooserPanel.html)

<!-- dummy comment line for breaking list -->

## コメント
