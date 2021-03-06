---
layout: post
category: swing
folder: RotatedVerticalTextTabs
title: JTabbedPaneのタブタイトル文字列を回転して縦組表示する
tags: [JTabbedPane, AffineTransform]
author: aterai
pubdate: 2020-03-30T02:03:22+09:00
description: JTabbedPaneのタブタイトル文字列をタブ配置の左右に応じて回転して縦長になるよう設定します。
image: https://drive.google.com/uc?id=1GSBG4hscI1mhP8nMGMvgdjd5zK66537Y
hreflang:
    href: https://java-swing-tips.blogspot.com/2020/03/rotate-tab-title-of-jtabbedpane.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`のタブタイトル文字列をタブ配置の左右に応じて回転して縦長になるよう設定します。

{% download https://drive.google.com/uc?id=1GSBG4hscI1mhP8nMGMvgdjd5zK66537Y %}

## サンプルコード
<pre class="prettyprint"><code>private Icon makeVerticalTabIcon(String title, Icon icon, boolean clockwise) {
  JLabel label = new JLabel(title, icon, SwingConstants.LEADING);
  label.setBorder(BorderFactory.createEmptyBorder(0, 2, 0, 2));
  Dimension d = label.getPreferredSize();
  int w = d.height;
  int h = d.width;
  BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
  Graphics2D g2 = (Graphics2D) bi.getGraphics();
  AffineTransform at = clockwise
      ? AffineTransform.getTranslateInstance(w, 0)
      : AffineTransform.getTranslateInstance(0, h);
  at.quadrantRotate(clockwise ? 1 : -1);
  g2.setTransform(at);
  SwingUtilities.paintComponent(g2, label, this, 0, 0, d.width, d.height);
  g2.dispose();
  return new ImageIcon(bi);
}
</code></pre>

## 解説
上記のサンプルでは、タイトル文字列とアイコンから`JLabel`を作成しこれを`90`°回転して`ImageIcon`に変換し、そのアイコンのみ(タイトル文字列は`null`)を`JTabbedPane#addTab(...)`で追加して横長ではなく縦長のタブを表示しています。

- 左: `JTabbedPane#setTabPlacement(LEFT)`
    - タブ用の`JLabel`の幅だけ`y`軸方向に移動し、反時計回りに`90`°回転した`JLabel`を描画する`Icon`を縦長タブとして使用
- 右: `JTabbedPane#setTabPlacement(RIGHT)`
    - タブ用の`JLabel`の高さだけ`x`軸方向に移動し、時計回りに`90`°回転した`JLabel`を描画する`Icon`を縦長タブとして使用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Iconを回転する](https://ateraimemo.com/Swing/RotatedIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
