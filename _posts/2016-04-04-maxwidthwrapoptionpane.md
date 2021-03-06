---
layout: post
category: swing
folder: MaxWidthWrapOptionPane
title: JOptionPaneに配置するJTextAreaの最大幅を指定してサイズ調整を行う
tags: [JTextArea, JOptionPane, JScrollPane]
author: aterai
pubdate: 2016-04-04T00:35:06+09:00
description: JOptionPaneに配置するJTextAreaの最大幅を指定し、テキストが複数行になってもその幅を超えず、スクロールバーも表示されない高さまで拡張されるよう設定します。
image: https://lh3.googleusercontent.com/-wvgqUKEkJe8/VwE0eREDhVI/AAAAAAAAOSM/aEgf3UtLBX0g-u9CKBFg_8nCbt7-0CLngCCo/s800-Ic42/MaxWidthWrapOptionPane.png
comments: true
---
## 概要
`JOptionPane`に配置する`JTextArea`の最大幅を指定し、テキストが複数行になってもその幅を超えず、スクロールバーも表示されない高さまで拡張されるよう設定します。

{% download https://lh3.googleusercontent.com/-wvgqUKEkJe8/VwE0eREDhVI/AAAAAAAAOSM/aEgf3UtLBX0g-u9CKBFg_8nCbt7-0CLngCCo/s800-Ic42/MaxWidthWrapOptionPane.png %}

## サンプルコード
<pre class="prettyprint"><code>private final JTextArea textArea = new JTextArea(1, 1) {
  @Override public void updateUI() {
    super.updateUI();
    setLineWrap(true);
    setWrapStyleWord(true);
    setEditable(false);
    setOpaque(false);
    //setBorder(BorderFactory.createLineBorder(Color.RED));
    setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
  }
  @Override public void setText(String t) {
    super.setText(t);
    try {
      setColumns(50);
      // javax/swing/text/JTextComponent.html#modelToView-int-
      // i.e. layout cannot be computed until the component has been sized.
      // The component does not have to be visible or painted.
      setSize(super.getPreferredSize()); // setSize: looks like ugly hack...
      System.out.println(super.getPreferredSize());

      Rectangle r = modelToView(t.length());
      int rc = (int)(.5 + (r.y + r.height) / (float) getRowHeight());
      setRows(rc);
      System.out.format("Rows: %d%n", rc);
      System.out.println(super.getPreferredSize());
      if (rc == 1) {
        setSize(getPreferredSize());
        setColumns(1);
      }
    } catch (BadLocationException ex) {
      ex.printStackTrace();
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JTextArea#setText(...)`メソッドをオーバーライドして最大幅を固定した`JTextArea`を作成し、これを`JOptionPane#showMessageDialog(...)`で表示しています。

- 文字列が`JTextArea#setColumns(50)`で指定した最大幅を超えて複数行になる場合は、スクロールバーが表示されないように`JTextArea#setSize(super.getPreferredSize())`で`JTextArea`の高さを調整
- 文字列が一行以内になる場合は、`JTextArea#setColumns(1)`で幅を上書きして、文字列の幅がそのサイズになるよう設定
- `NimbusLookAndFeel`や`MotifLookAndFeel`で一行分の`JTextArea`の幅設定ができない？
    - `JTextArea`の内余白が影響している？
- `JTextArea#setText(...)`時点でのサイズを設定し、ダイアログのリサイズは考慮しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Use width and max-width to wrap text in JOptionPane - Stack Overflow](https://stackoverflow.com/questions/35405672/use-width-and-max-width-to-wrap-text-in-joptionpane)
- [JTextComponent#modelToView(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/JTextComponent.html#modelToView-int-)

<!-- dummy comment line for breaking list -->

## コメント
