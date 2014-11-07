---
layout: post
category: swing
folder: SpinnerTextColor
title: JComboBoxをJSpinnerの代わりに使用する
tags: [JSpinner, JComboBox, Html, ActionMap]
author: aterai
pubdate: 2013-04-29T08:31:48+09:00
description: JSpinnerの代わりにJComboBoxを使用することで、アイテムの文字色などを変更しています。
comments: true
---
## 概要
`JSpinner`の代わりに`JComboBox`を使用することで、アイテムの文字色などを変更しています。

{% download https://lh6.googleusercontent.com/-kpruQCgOnLE/UX2r6exfrII/AAAAAAAABqo/JZnFlTBy1zw/s800/SpinnerTextColor.png %}

## サンプルコード
<pre class="prettyprint"><code>JButton nb = createArrowButton(SwingConstants.NORTH);
nb.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    e.setSource(comboBox);
    comboBox.getActionMap().get("selectPrevious2").actionPerformed(e);
  }
});
JButton sb = createArrowButton(SwingConstants.SOUTH);
sb.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    e.setSource(comboBox);
    comboBox.getActionMap().get("selectNext2").actionPerformed(e);
  }
});
Box box = Box.createVerticalBox();
box.add(nb);
box.add(sb);

JPanel p = new JPanel(new BorderLayout()) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    return new Dimension(d.width, 20);
  }
};
p.add(comboBox);
p.add(box, BorderLayout.EAST);
</code></pre>

## 解説
上記のサンプルでは、ドロップダウンリストを無効(表示させない)にした`JComboBox`と`2`つの`ArrowButton`を組み合わせて、`JSpinner`風のコンポーネントを作成しています。各アイテムの文字色は、`Html`の`<font>`タグを使って変更しています。

- `BasicComboBoxUI#createArrowButton()`をオーバーライドして、`JComboBox`の元`ArrowButton`を非表示
    - [JComboBoxのArrowButtonを隠す](http://ateraimemo.com/Swing/HideComboArrowButton.html)
- `BasicComboBoxUI#setPopupVisible`、`BasicComboBoxUI#createPopup()`、`BasicComboPopup#show()`などをオーバーライドしてドロップダウンリストを無効化
- `JComboBox#getActionMap()#get("selectNext2")`などで取得したアクションを実行する`ArrowButton`を作成してレイアウト
    - [JTableを別コンポーネントから操作](http://ateraimemo.com/Swing/SelectAllButton.html)
    - [JComponentのKeyBinding一覧を取得する](http://ateraimemo.com/Swing/KeyBinding.html)
    - リピート機能には未対応

<!-- dummy comment line for breaking list -->

## コメント
