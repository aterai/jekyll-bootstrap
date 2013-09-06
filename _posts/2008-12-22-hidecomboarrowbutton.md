---
layout: post
title: JComboBoxのArrowButtonを隠す
category: swing
folder: HideComboArrowButton
tags: [JComboBox, ArrowButton, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-12-22

## JComboBoxのArrowButtonを隠す
`ArrowButton`を隠して、`JComboBox`の表示を`JLabel`風にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN0Yp0GRI/AAAAAAAAAbY/WvXw5vm2_LI/s800/HideComboArrowButton.png)

### サンプルコード
<pre class="prettyprint"><code>JPanel p = new JPanel(new BorderLayout(5, 5));
Object[] items = {"JComboBox 11111:", "JComboBox 222:", "JComboBox 33:"};

UIManager.put("ComboBox.squareButton", Boolean.FALSE);
JComboBox comboBox = new JComboBox(items);
comboBox.setUI(new BasicComboBoxUI() {
  @Override protected JButton createArrowButton() {
    JButton button = new JButton(); //super.createArrowButton();
    button.setBorder(BorderFactory.createEmptyBorder());
    button.setVisible(false);
    return button;
  }
});
comboBox.setOpaque(true);
comboBox.setBackground(p.getBackground());
comboBox.setBorder(BorderFactory.createEmptyBorder(0,2,0,2));
comboBox.setFocusable(false);

UIManager.put("ComboBox.squareButton", Boolean.TRUE);
</code></pre>

### 解説
上記のサンプルでは、以下のようにして、`JComboBox`を`JLabel`風に表示しています。

- `UIManager.put("ComboBox.squareButton", Boolean.FALSE);`で、`ArrowButton`の幅をそのまま使用するように変更
- `BasicComboBoxUI#createArrowButton`をオーバーライドして、`ArrowButton`の代わりに幅高さ`0`で`setVisible(false)`なボタンを作成
- `JComboBox`の背景色を親の`JPanel`と同じにする
- `JComboBox`がフォーカスを取得しないようにする

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - Hide JComboBox Arrow?](https://forums.oracle.com/thread/1359216)
- [Bug ID: 6337518 Null Arrow Button Throws Exception in BasicComboBoxUI](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6337518)

<!-- dummy comment line for breaking list -->

### コメント
