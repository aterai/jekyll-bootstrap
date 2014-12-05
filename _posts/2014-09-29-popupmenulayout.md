---
layout: post
category: swing
folder: PopupMenuLayout
title: JPopupMenuのレイアウトを変更して上部にメニューボタンを追加する
tags: [JPopupMenu, GridBagLayout, JMenuItem, Icon]
author: aterai
pubdate: 2014-09-29T00:00:12+09:00
description: JPopupMenuのレイアウトを変更することで、上部にメニューボタンを水平に並べて表示します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2014/09/change-layout-of-jpopupmenu-to-use.html
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
c.gridheight = 1;

c.weightx = 1.0;
c.weighty = 0.0;
c.fill = GridBagConstraints.HORIZONTAL;
c.anchor = GridBagConstraints.CENTER;

c.gridwidth = 1;
c.gridy = 0;
c.gridx = 0; popup.add(makeButton("\u21E6"), c);
c.gridx = 1; popup.add(makeButton("\u21E8"), c);
c.gridx = 2; popup.add(makeButton("\u21BB"), c);
c.gridx = 3; popup.add(makeButton("\u2729"), c);

c.gridwidth = 4;
c.gridx = 0;
c.insets = new Insets(2, 0, 2, 0);
c.gridy = 1; popup.add(new JSeparator(), c);
c.insets = new Insets(0, 0, 0, 0);
c.gridy = 2; popup.add(new JMenuItem("aaaaaaaaaa"), c);
c.gridy = 3; popup.add(new JPopupMenu.Separator(), c);
c.gridy = 4; popup.add(new JMenuItem("bbbb"), c);
c.gridy = 5; popup.add(new JMenuItem("ccccccccccccccccccccc"), c);
c.gridy = 6; popup.add(new JMenuItem("dddddddddd"), c);
</code></pre>

## 解説
上記のサンプルでは、`JPopupMenu`のレイアウトを`GridBagLayout`に変更して、上部に`4`つのメニューボタンを水平に並べて表示(`FireFox`風？)します。

これらのメニューボタンは、`JMenuItem`の以下のメソッドをオーバーライドすることで、ボタン風に表示を変更しています。
- `JMenuItem#paintComponent(...)`をオーバーライドして`32x32`の`Icon`のみを直接描画
    - `JMenuItem#setIcon(...)`を使用すると、文字列の左側に`Icon`が表示される
    - ボタン中央に`Icon`が描画されるように位置を計算する(`GridBagLayout`で`GridBagConstraints.HORIZONTAL`と水平方向に拡張しているため、`getSize()`で現在のボタンサイズを取得して中央を求める)
- `JMenuItem#getPreferredSize()`をオーバーライドして、`Icon`のサイズを推奨サイズとして返す
    - `JMenuItem#setIcon(...)`を使用していないので、直接`Icon`のサイズを渡す必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final Icon icon = new SymbolIcon(symbol);
JMenuItem b = new JMenuItem() {
  private final Dimension d = new Dimension(icon.getIconWidth(), icon.getIconHeight());
  @Override public Dimension getPreferredSize() {
    return d;
  }
  @Override public void paintComponent(Graphics g) {
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
- [JMenuItemの内部にJButtonを配置する](http://ateraimemo.com/Swing/ButtonsInMenuItem.html)
    - こちらは、`JPopupMenu`のレイアウトを変更するのではなく、`JMenuItem`のレイアウトを変更して、`JMenuItem`の子としてボタンを追加している
- [JPopupMenuをボタンの長押しで表示](http://ateraimemo.com/Swing/PressAndHoldButton.html)

<!-- dummy comment line for breaking list -->

## コメント