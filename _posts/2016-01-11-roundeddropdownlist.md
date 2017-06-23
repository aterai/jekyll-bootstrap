---
layout: post
category: swing
folder: RoundedDropDownList
title: JComboBoxのドロップダウンリストに角丸のBorderを設定する
tags: [JComboBox, BasicComboPopup, JPopupMenu, Border]
author: aterai
pubdate: 2016-01-11T00:02:17+09:00
description: JComboBoxからBasicComboPopupを取得し、これに角丸のBorderを設定します。
image: https://lh3.googleusercontent.com/-hO6OrwNE6O4/VpJu21j7FbI/AAAAAAAAOLA/mUBgzYUJpes/s800-Ic42/RoundedDropDownList.png
comments: true
---
## 概要
`JComboBox`から`BasicComboPopup`を取得し、これに角丸の`Border`を設定します。

{% download https://lh3.googleusercontent.com/-hO6OrwNE6O4/VpJu21j7FbI/AAAAAAAAOLA/mUBgzYUJpes/s800-Ic42/RoundedDropDownList.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo1 = new JComboBox&lt;String&gt;(makeModel()) {
  private transient PopupMenuListener listener;
  @Override public void updateUI() {
    removePopupMenuListener(listener);
    UIManager.put("ComboBox.border", new RoundedCornerBorder());
    super.updateUI();
    setUI(new BasicComboBoxUI());
    listener = new HeavyWeightContainerListener();
    addPopupMenuListener(listener);
    Object o = getAccessibleContext().getAccessibleChild(0);
    if (o instanceof JComponent) {
      JComponent c = (JComponent) o;
      c.setBorder(new RoundedCornerBorder());
      c.setForeground(FOREGROUND);
      c.setBackground(BACKGROUND);
    }
  }
};
</code></pre>

## 解説
- 上:
    - `UIManager.put(...)`で背景色などを変更し、`BasicComboBoxUI`を設定した`JComboBox`
- 中:
    - 上の`JComboBox`から、`getAccessibleContext().getAccessibleChild(0)`で`BasicComboPopup`を取得し、角丸の`Border`を設定
    - `JComboBox`に`PopupMenuListener`を追加し、ドロップダウンリストが`JFrame`の外側にはみ出す(`HeavyWeightContainer`の`JWindow`に`JPopupMenu`が配置されてるい)場合は、`JWindow`の背景を透明化して角丸部分を非表示に設定
- 下:
    - 中の`JComboBox`と同様に`BasicComboPopup`を取得し、下辺のみ角丸の`Border`を設定(`JComboBox`自体には上辺のみ角丸の`Border`を設定)
    - `ArrowButton`を変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxの角を丸める](http://ateraimemo.com/Swing/RoundedComboBox.html)
- [java - Rounded Corner for JComboBox - Stack Overflow](https://stackoverflow.com/questions/34503780/rounded-corner-for-jcombobox/34534091#34534091)

<!-- dummy comment line for breaking list -->

## コメント
