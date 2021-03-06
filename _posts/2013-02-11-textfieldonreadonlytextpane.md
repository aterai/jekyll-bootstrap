---
layout: post
category: swing
folder: TextFieldOnReadOnlyTextPane
title: JTextFieldを編集不可のJTextPaneに追加する
tags: [JTextPane, JTextField, JScrollPane, Focus]
author: aterai
pubdate: 2013-02-11T00:11:13+09:00
description: JTextFieldを空欄として編集不可にしたJTextPaneに追加します。
image: https://lh4.googleusercontent.com/-N1aQ1F9Zrn8/UReetdvfWQI/AAAAAAAABdc/9J_2lkAgW0Y/s800/TextFieldOnReadOnlyTextPane.png
comments: true
---
## 概要
`JTextField`を空欄として編集不可にした`JTextPane`に追加します。

{% download https://lh4.googleusercontent.com/-N1aQ1F9Zrn8/UReetdvfWQI/AAAAAAAABdc/9J_2lkAgW0Y/s800/TextFieldOnReadOnlyTextPane.png %}

## サンプルコード
<pre class="prettyprint"><code>void insertQuestion(final JTextPane textPane, String str) {
  Document doc = textPane.getDocument();
  try {
    doc.insertString(doc.getLength(), str, null);
    final int pos = doc.getLength();
    System.out.println(pos);
    final JTextField field = new JTextField(4) {
      @Override public Dimension getMaximumSize() {
        return getPreferredSize();
      }
    };
    field.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, Color.BLACK));
    field.addFocusListener(new FocusAdapter() {
      @Override public void focusGained(FocusEvent e) {
        try {
          Rectangle rect = textPane.modelToView(pos);
          rect.grow(0, 4);
          rect.setSize(field.getSize());
          textPane.scrollRectToVisible(rect);
        } catch (BadLocationException ex) {
          ex.printStackTrace();
        }
      }
    });
    Dimension d = field.getPreferredSize();
    int baseline = field.getBaseline(d.width, d.height);
    field.setAlignmentY(baseline / (float) d.height);

    SimpleAttributeSet a = new SimpleAttributeSet();
    StyleConstants.setLineSpacing(a, 1.5f);
    textPane.setParagraphAttributes(a, true);

    textPane.insertComponent(field);
    doc.insertString(doc.getLength(), "\n", null);
  } catch (BadLocationException e) {
    e.printStackTrace();
  }
}
</code></pre>

## 解説
上記のサンプルでは、編集不可状態の`JTextPane`内の文字列中に編集可能な`JTextField`を`JTextPane#insertComponent(...)`メソッドを使用して追加しています。

- `JTextPane`
    - 編集不可に設定
    - 行間を`1.5`倍に設定
        - [JEditorPaneやJTextPaneに行間を設定する](https://ateraimemo.com/Swing/LineSpacing.html)
- `JTextField`
    - `JTextField#getMaximumSize()`をオーバーライドして幅を制限
    - `JTextField`に`MatteBorder`を設定して下線のみの空欄を表示
    - `JTextField#setAlignmentY(...)`でベースラインを揃える
        - [JTextPaneに追加するコンポーネントのベースラインを揃える](https://ateraimemo.com/Swing/InsertComponentBaseline.html)
    - `JTextField`に`FocusListener`を追加し、<kbd>Tab</kbd>キーなどで`Focus`が移動したら、その`JTextField`までスクロールするように設定
        - [FocusTraversalPolicyを使用してフォーカスを取得したコンポーネントまでスクロールする](https://ateraimemo.com/Swing/AutoScrollOnFocus.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextPane#insertComponent(Component) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTextPane.html#insertComponent-java.awt.Component-)

<!-- dummy comment line for breaking list -->

## コメント
