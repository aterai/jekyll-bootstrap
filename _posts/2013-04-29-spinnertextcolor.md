---
layout: post
title: JComboBoxをJSpinnerの代わりに使用する
category: swing
folder: SpinnerTextColor
tags: [JSpinner, JComboBox, Html, ActionMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-04-29

## JComboBoxをJSpinnerの代わりに使用する
`JSpinner`の代わりに`JComboBox`を使用することで、アイテムの文字色などを変更しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-kpruQCgOnLE/UX2r6exfrII/AAAAAAAABqo/JZnFlTBy1zw/s800/SpinnerTextColor.png)

### サンプルコード
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

### 解説
上記のサンプルでは、ドロップダウンリストを無効(表示させない)にした`JComboBox`と`2`つの`ArrowButton`を組み合わせて、`JSpinner`風のコンポーネントを作成しています。各アイテムの文字色は、`Html`の`<font>`タグを使って変更しています。

- `BasicComboBoxUI#createArrowButton()`をオーバーライドして、`JComboBox`の元`ArrowButton`を非表示
    - [JComboBoxのArrowButtonを隠す](http://terai.xrea.jp/Swing/HideComboArrowButton.html)
- `BasicComboBoxUI#setPopupVisible`、`BasicComboBoxUI#createPopup()`、`BasicComboPopup#show()`などをオーバーライドしてドロップダウンリストを無効化
- `JComboBox#getActionMap()#get("selectNext2")`などで取得したアクションを実行する`ArrowButton`を作成してレイアウト
    - [JTableを別コンポーネントから操作](http://terai.xrea.jp/Swing/SelectAllButton.html)
    - [JComponentのKeyBinding一覧を取得する](http://terai.xrea.jp/Swing/KeyBinding.html)
    - リピート機能には未対応

<!-- dummy comment line for breaking list -->

### コメント
