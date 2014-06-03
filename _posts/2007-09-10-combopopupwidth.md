---
layout: post
title: JComboBoxのドロップダウンリスト幅を指定値以上に保つ
category: swing
folder: ComboPopupWidth
tags: [JComboBox, PopupMenuListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-09-10

## JComboBoxのポップアップ幅を指定値以上に保つ
`JComboBox`のドロップダウンリストが表示されたとき、本体の幅が狭くても一定の幅以下にはならないように設定します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ8wQD77I/AAAAAAAAAVM/Ade6cu49JUQ/s800/ComboPopupWidth.png)

### サンプルコード
<pre class="prettyprint"><code>class MinWidthPopupMenuListener implements PopupMenuListener{
  private static final int POPUP_MIN_WIDTH = 320;
  private boolean adjusting = false;
  @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
    JComboBox combo = (JComboBox)e.getSource();
    Dimension size  = combo.getSize();
    if(size.width&gt;=POPUP_MIN_WIDTH) return;
    if(!adjusting) {
      adjusting = true;
      combo.setSize(POPUP_MIN_WIDTH, size.height);
      combo.showPopup();
    }
    combo.setSize(size);
    adjusting = false;
  }
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
  @Override public void popupMenuCanceled(PopupMenuEvent e) {}
}
</code></pre>

### 解説
上記のサンプルでは、下二つの`JComboBox`に`PopupMenuListener`を実装したリスナーを設定しています。このリスナーでは、ポップアップメニュー(ドロップダウンリスト)が開かれる前に`JComboBox`本体の幅を指定値と比較し、小さかった場合は以下のような通常とは異なる手順でポップアップメニューの表示を行っています。

- `JComboBox`のサイズを取得し保存
- `JComboBox`の幅を指定値まで拡大
- `JComboBox#showPopup`でポップアップメニューを表示
    - ポップアップメニューの幅も、指定値まで拡大している
- `JComboBox`本体のサイズを保存していた元の値に戻す

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - How to widen the drop-down list in a JComboBox](https://forums.oracle.com/thread/1368300)
    - dlinderm さんの投稿(2007/06/08 23:24)を参考にして、`PopupMenuListener`を使用しています。
- [Make JComboBox popup wide enough - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/make_jcombobox_popup_wide_enough)
    - こちらには、`JComboBox#doLayout()`と、`JComboBox#getSize()`をオーバーライドして、十分な幅のドロップダウンリストを表示するサンプルがあります。

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [Bug ID: 4743225 Size of JComboBox list is wrong when list is populated via PopupMenuListener](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4743225)  -- [aterai](http://terai.xrea.jp/aterai.html) 2011-06-05 (日) 02:34:16

<!-- dummy comment line for breaking list -->

