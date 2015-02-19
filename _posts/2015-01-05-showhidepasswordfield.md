---
layout: post
category: swing
folder: ShowHidePasswordField
title: JPasswordFieldでパスワードを可視化する
tags: [JPasswordField, JTextField, CardLayout, OverlayLayout]
author: aterai
pubdate: 2015-01-05T00:29:05+09:00
description: JPasswordFieldのパスワードを可視化するため、ドキュメントを共有するJTextFieldを作成して、これをCardLayoutで切り替えます。
hreflang:
    href: http://java-swing-tips.blogspot.com/2015/01/showhide-passwordfield-using-cardlayout.html
    lang: en
comments: true
---
## 概要
`JPasswordField`のパスワードを可視化するため、ドキュメントを共有する`JTextField`を作成して、これを`CardLayout`で切り替えます。

{% download https://lh6.googleusercontent.com/-xn92BzP3qq4/VKkJzJGgYLI/AAAAAAAANuY/RnuIMAoCGzs/s800/ShowHidePasswordField.png %}

## サンプルコード
<pre class="prettyprint"><code>JPasswordField pf = new JPasswordField(24);
pf.setText("abcdefghijklmn");
AbstractDocument doc = (AbstractDocument) pf.getDocument();
doc.setDocumentFilter(new ASCIIOnlyDocumentFilter());

JTextField tf = new JTextField(24);
tf.setFont(FONT);
tf.enableInputMethods(false);
tf.setDocument(doc);

final CardLayout cardLayout = new CardLayout();
final JPanel p = new JPanel(cardLayout);
p.setAlignmentX(Component.RIGHT_ALIGNMENT);

p.add(pf, PasswordField.HIDE.toString());
p.add(tf, PasswordField.SHOW.toString());

AbstractButton b = new JToggleButton(new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    AbstractButton c = (AbstractButton) e.getSource();
    PasswordField s = c.isSelected() ? PasswordField.SHOW : PasswordField.HIDE;
    cardLayout.show(p, s.toString());
  }
});
</code></pre>

## 解説
- 上: `CardLayout`
    - 同じ`Document`を使用する`JPasswordField`と`JTextField`を`CardLayout`を設定した`JPanel`に配置して`JCheckBox`で切り替え
    - `textField.enableInputMethods(false);`として、インプットメソッドを使用不可に設定
- 中: `CardLayout` + `ASCII only filter`
    - 同じ`Document`を使用する`JPasswordField`と`JTextField`を`CardLayout`を設定した`JPanel`に配置して`JCheckBox`で切り替え
    - `textField.enableInputMethods(false);`として、インプットメソッドを使用不可に設定
    - `ASCII`以外の文字がコピー・ペーストなどできないようにする`DocumentFilter`を作成して`Document`に設定
- 下: `CardLayout` + `OverlayLayout`
    - 同じ`Document`を使用する`JPasswordField`と`JTextField`を`CardLayout`を設定した`JPanel`を作成
    - `OverlayLayout`を設定した`JPanel`に、上記の`JPanel`と`JToggleButton`を配置し、`JPasswordField`などの内部右端にボタンが表示されるように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final CardLayout cardLayout = new CardLayout();
final JPanel p = new JPanel(cardLayout);
p.setAlignmentX(Component.RIGHT_ALIGNMENT);

p.add(pf, PasswordField.HIDE.toString());
p.add(tf, PasswordField.SHOW.toString());

AbstractButton b = new JToggleButton(new AbstractAction() {
  //...
});
b.setFocusable(false);
b.setOpaque(false);
b.setContentAreaFilled(false);
b.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 4));
b.setAlignmentX(Component.RIGHT_ALIGNMENT);
b.setAlignmentY(Component.CENTER_ALIGNMENT);
b.setIcon(new ColorIcon(Color.GREEN));
b.setRolloverIcon(new ColorIcon(Color.BLUE));
b.setSelectedIcon(new ColorIcon(Color.RED));
b.setRolloverSelectedIcon(new ColorIcon(Color.ORANGE));

JPanel panel = new JPanel() {
  @Override public boolean isOptimizedDrawingEnabled() {
    return false;
  }
};
panel.setLayout(new OverlayLayout(panel));
panel.add(b);
</code></pre>

## コメント