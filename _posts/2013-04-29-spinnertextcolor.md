---
layout: post
category: swing
folder: SpinnerTextColor
title: JComboBoxをJSpinnerの代わりに使用する
tags: [JSpinner, JComboBox, ListCellRenderer, Html, ActionMap]
author: aterai
pubdate: 2013-04-29T08:31:48+09:00
description: JSpinnerの代わりにJComboBoxを使用することで、アイテムの文字色などを変更しています。
image: https://lh6.googleusercontent.com/-kpruQCgOnLE/UX2r6exfrII/AAAAAAAABqo/JZnFlTBy1zw/s800/SpinnerTextColor.png
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
上記のサンプルでは、ドロップダウンリストの表示を無効にした`JComboBox`と`2`つの`ArrowButton`を組み合わせて、`JSpinner`風のコンポーネントを作成しています。`JComboBox`のデフォルトセルレンダラーは`JLabel`を継承していて`Html`タグが使用可能なので、各アイテムの文字色を`<font>`タグで部分的に変更しています。

- `BasicComboBoxUI#createArrowButton()`メソッドをオーバーライドして、`JComboBox`の`ArrowButton`を非表示に設定
    - [JComboBoxのArrowButtonを隠す](https://ateraimemo.com/Swing/HideComboArrowButton.html)
- `BasicComboBoxUI#setPopupVisible(...)`、`BasicComboBoxUI#createPopup()`、`BasicComboPopup#show()`メソッドなどをオーバーライドしてドロップダウンリストを無効化
- `JComboBox#getActionMap()#get("selectNext2")`などで取得したアクションを実行する`ArrowButton`を作成してレイアウト
    - [JTableを別コンポーネントから操作](https://ateraimemo.com/Swing/SelectAllButton.html)
    - [JComponentのKeyBinding一覧を取得する](https://ateraimemo.com/Swing/KeyBinding.html)
- ボタンをクリックしたままの場合、値変更が繰り返し実行されるリピート機能には未対応
    - [JButtonがマウスで押されている間、アクションを繰り返すTimerを設定する](https://ateraimemo.com/Swing/AutoRepeatTimer.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのArrowButtonを隠す](https://ateraimemo.com/Swing/HideComboArrowButton.html)
- [JTableを別コンポーネントから操作](https://ateraimemo.com/Swing/SelectAllButton.html)
- [JComponentのKeyBinding一覧を取得する](https://ateraimemo.com/Swing/KeyBinding.html)
- [JButtonがマウスで押されている間、アクションを繰り返すTimerを設定する](https://ateraimemo.com/Swing/AutoRepeatTimer.html)
- [JSpinnerのエディタをJLabelに変更してHTMLを表示する](https://ateraimemo.com/Swing/HtmlSpinnerEditor.html)
    - `JSpinner`の`Editor`を`JFormattedTextField`から`JLabel`に変更して同様の文字色変更を行うサンプル

<!-- dummy comment line for breaking list -->

## コメント
