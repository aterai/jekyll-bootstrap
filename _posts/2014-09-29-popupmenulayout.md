---
layout: post
category: swing
folder: PopupMenuLayout
title: JPopupMenuのレイアウトを変更して上部にメニューボタンを追加する
tags: [JPopupMenu, GridBagLayout, JMenuItem, Icon, LayoutManager]
author: aterai
pubdate: 2014-09-29T00:00:12+09:00
description: JPopupMenuのレイアウトを変更することで、上部にメニューボタンを水平に並べて表示します。
image: https://lh6.googleusercontent.com/-puZjATgiuLQ/VCgMaUlMzLI/AAAAAAAACN0/PkEeTJkX7Hg/s800/PopupMenuLayout.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2014/09/change-layout-of-jpopupmenu-to-use.html
    lang: en
comments: true
---
## 概要
`JPopupMenu`のレイアウトを変更することで、上部にメニューボタンを水平に並べて表示します。

{% download https://lh6.googleusercontent.com/-puZjATgiuLQ/VCgMaUlMzLI/AAAAAAAACN0/PkEeTJkX7Hg/s800/PopupMenuLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>JPopupMenu popup = new JPopupMenu();
GridBagConstraints c = new GridBagConstraints();
popup.setLayout(new GridBagLayout());

c.weightx = 1d;
c.weighty = 0d;
c.fill = GridBagConstraints.HORIZONTAL;
c.anchor = GridBagConstraints.CENTER;

c.gridy = 0;
popup.add(makeButton("\u21E6"), c);
popup.add(makeButton("\u21E8"), c);
popup.add(makeButton("\u21BB"), c);
popup.add(makeButton("\u2729"), c);

c.insets = new Insets(2, 0, 2, 0);
c.gridwidth = 4;
c.gridx = 0;
c.gridy = GridBagConstraints.RELATIVE;
popup.add(new JSeparator(), c);

c.insets = new Insets(0, 0, 0, 0);
popup.add(new JMenuItem("aaaaaaaaaa"), c);
popup.add(new JPopupMenu.Separator(), c);
popup.add(new JMenuItem("bbbb"), c);
popup.add(new JMenuItem("ccccccccccccccccccccc"), c);
popup.add(new JMenuItem("dddddddddd"), c);
</code></pre>

## 解説
上記のサンプルでは、`JPopupMenu`のレイアウトを`GridBagLayout`に変更して、上部に`4`つのメニューボタンを水平に並べて表示しています。

これらのメニューボタンは、`JMenuItem`の以下のメソッドをオーバーライドすることで、ボタン風に表示を変更しています。
- `JMenuItem#paintComponent(...)`をオーバーライドして`32x32`の`Icon`のみを直接描画
    - `JMenuItem#setIcon(...)`を使用すると文字列の左側に`Icon`が表示される
    - ボタン中央に`Icon`が描画されるように位置を計算する
        - `GridBagLayout`で`GridBagConstraints.HORIZONTAL`と水平方向に拡張しているため`getSize()`で現在のボタンサイズを取得して中央を求める
- `JMenuItem#getPreferredSize()`をオーバーライドして`Icon`のサイズを推奨サイズとして返す
    - `JMenuItem#setIcon(...)`を使用していないので直接`Icon`のサイズを渡す必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final Icon icon = new SymbolIcon(symbol);
JMenuItem b = new JMenuItem() {
  private final Dimension d = new Dimension(icon.getIconWidth(), icon.getIconHeight());

  @Override public Dimension getPreferredSize() {
    return d;
  }

  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    Dimension cd = getSize();
    Dimension pd = getPreferredSize();
    int offx = (int) (.5 + .5 * (cd.width  - pd.width));
    int offy = (int) (.5 + .5 * (cd.height - pd.height));
    icon.paintIcon(this, g, offx, offy);
  }
};
b.setOpaque(true);
</code></pre>

## 参考リンク
- [JMenuItemの内部にJButtonを配置する](https://ateraimemo.com/Swing/ButtonsInMenuItem.html)
    - こちらは、`JPopupMenu`のレイアウトを変更するのではなく、`JMenuItem`のレイアウトを変更して、`JMenuItem`の子としてボタンを追加している
- [JPopupMenuをボタンの長押しで表示](https://ateraimemo.com/Swing/PressAndHoldButton.html)

<!-- dummy comment line for breaking list -->

## コメント
