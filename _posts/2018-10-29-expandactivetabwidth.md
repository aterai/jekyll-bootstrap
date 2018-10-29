---
layout: post
category: swing
folder: ExpandActiveTabWidth
title: JTabbedPaneで選択されているタブの幅のみ拡張する
tags: [JTabbedPane]
author: aterai
pubdate: 2018-10-29T16:08:36+09:00
description: JTabbedPaneで現在選択されているタブの幅は拡張、その他のタブは縮小するよう設定します。
image: https://drive.google.com/uc?id=1NIZXoyEHh-K_H-BZ83l3pG5phVRjpmOzbQ
comments: true
---
## 概要
`JTabbedPane`で現在選択されているタブの幅は拡張、その他のタブは縮小するよう設定します。

{% download https://drive.google.com/uc?id=1NIZXoyEHh-K_H-BZ83l3pG5phVRjpmOzbQ %}

## サンプルコード
<pre class="prettyprint"><code>public static void updateTabWidth(JTabbedPane tabs) {
  int tp = tabs.getTabPlacement();
  if (tp == JTabbedPane.LEFT || tp == JTabbedPane.RIGHT) {
    return;
  }
  int sidx = tabs.getSelectedIndex();
  for (int i = 0; i &lt; tabs.getTabCount(); i++) {
    Component c = tabs.getTabComponentAt(i);
    if (c instanceof ShrinkLabel) {
      ((ShrinkLabel) c).setSelected(i == sidx);
    }
  }
}

class ShrinkLabel extends JLabel {
  private boolean isSelected;
  protected ShrinkLabel(String title, Icon icon) {
    super(title, icon, SwingConstants.LEFT);
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    if (!isSelected) {
      d.width = 20;
    }
    return d;
  }
  public void setSelected(boolean active) {
    this.isSelected = active;
  }
  public boolean isSelected() {
    return isSelected;
  }
}
</code></pre>

## 解説
- `JTabbedPane#setTabComponentAt(...)`メソッドで、タブコンポーネントとして`JLabel`を設定
- `JLabel#getPreferredSize()`をオーバーライドして、選択されていない場合はその推奨サイズを縮小
    - 選択されている場合は、`super.getPreferredSize()`で元のサイズを返す
- `JTabbedPane`に`ChangeListener`を追加し、タブ選択が変更されたらすべてのタブコンポーネントの選択状態(推奨サイズ)を更新
- タブの配置が左右の場合は、選択されたタブの幅のみ変更しても意味がないのでこの処理は実行しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneの選択文字色を変更](https://ateraimemo.com/Swing/ColorTab.html)

<!-- dummy comment line for breaking list -->

## コメント
