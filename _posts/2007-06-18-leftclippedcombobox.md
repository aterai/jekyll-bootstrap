---
layout: post
category: swing
folder: LeftClippedComboBox
title: JComboBoxのアイテム文字列を左側からクリップ
tags: [JComboBox, ListCellRenderer, ArrowButton]
author: aterai
pubdate: 2007-06-18T19:09:42+09:00
description: JComboBoxのアイテム文字列がコンポーネントより長い場合、これを左側からクリップします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPEaiR2iI/AAAAAAAAAdY/E5fxUtKW0sM/s800/LeftClippedComboBox.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/05/left-clipped-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`のアイテム文字列がコンポーネントより長い場合、これを左側からクリップします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPEaiR2iI/AAAAAAAAAdY/E5fxUtKW0sM/s800/LeftClippedComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>final JButton arrowButton = getArrowButton(combo02);
combo02.setRenderer(new DefaultListCellRenderer() {
  @Override public Component getListCellRendererComponent(
    JList list, Object value, int index,
    boolean isSelected, boolean cellHasFocus) {
    super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
    int itb = 0, ilr = 0;
    Insets insets = getInsets();
    itb += insets.top + insets.bottom;
    ilr += insets.left + insets.right;
    insets = combo02.getInsets();
    itb += insets.top + insets.bottom;
    ilr += insets.left + insets.right;
    int availableWidth = combo02.getWidth() - ilr;
    if (index &lt; 0) {
      //@see BasicComboBoxUI#rectangleForCurrentValue
      int buttonSize = combo02.getHeight() - itb;
      if (arrowButton != null) {
        buttonSize = arrowButton.getWidth();
      }
      availableWidth -= buttonSize;
      JTextField tf = (JTextField) combo02.getEditor().getEditorComponent();
      insets = tf.getMargin();
      availableWidth -= (insets.left + insets.right);
    }
    String cellText = (value != null) ? value.toString() : "";
    //&lt;blockquote cite="https://tips4java.wordpress.com/2008/11/12/left-dot-renderer/"&gt;
    //@title Left Dot Renderer
    //@auther Rob Camick
    FontMetrics fm = getFontMetrics(getFont());
    if (fm.stringWidth(cellText) &gt; availableWidth) {
      String dots = "...";
      int textWidth = fm.stringWidth(dots);
      int nChars = cellText.length() - 1;
      while (nChars &gt; 0) {
        textWidth += fm.charWidth(cellText.charAt(nChars));
        if (textWidth &gt; availableWidth) break;
        nChars--;
      }
      setText(dots + cellText.substring(nChars + 1));
    }
    //&lt;/blockquote&gt;
    return this;
  }
});
</code></pre>

## 解説
- 標準の`JComboBox`が使用する`DefaultListCellRenderer`は`JLabel`を継承しているので、長い文字列は右側から省略される
- 上記のサンプルでは左側から省略し、`...`で置き換えるようにセルレンダラーを変更
    - 長いファイル名でも拡張子は省略されない
    - エディタ部分(`index < 0`の場合)を描画するときは、矢印ボタンの幅を考慮する必要がある
    - `LookAndFeel`によって余白などのサイズが微妙に異なる場合がある？
    - 補助文字(サロゲートペアなど)を含む文字列を扱う場合は、`String#charAt(int)`ではなく、`String#codePointAt(int)`や`Character.charCount(codePoint)`などを使用する必要がある
        - 参考: [Java による Unicode サロゲートプログラミング](https://www.ibm.com/developerworks/jp/ysl/library/java/j-unicode_surrogate/index.html)
        
        <pre class="prettyprint"><code>FontMetrics fm = getFontMetrics(getFont());
        if (fm.stringWidth(cellText) &gt; availableWidth) {
          String dots = "...";
          int textWidth = fm.stringWidth(dots);
          int len = cellText.length();
          int[] acp = new int[cellText.codePointCount(0, len)];
          int j = acp.length;
          for (int i = len; i &gt; 0; i = cellText.offsetByCodePoints(i, -1)) {
            int cp = cellText.codePointBefore(i);
            textWidth += fm.charWidth(cp);
            if (textWidth &gt; availableWidth) {
              break;
            }
            acp[--j] = cp;
          }
          setText(dots + new String(acp, j, acp.length - j));
        }
</code></pre>
    - * 参考リンク [#reference]
- [Swing - JTable - right align in cell even if the text is wider than the cell](https://community.oracle.com/thread/1389543)
    - camickr さんが投稿(2005/06/10 5:52)した`JTable`でのサンプルがある
- [Left Dot Renderer « Java Tips Weblog](https://tips4java.wordpress.com/2008/11/12/left-dot-renderer/)
- [Java による Unicode サロゲートプログラミング](https://www.ibm.com/developerworks/jp/ysl/library/java/j-unicode_surrogate/index.html)

<!-- dummy comment line for breaking list -->

## コメント
- 参考リンク、スクリーンショット更新。 -- *aterai* 2008-11-13 (木) 14:26:39

<!-- dummy comment line for breaking list -->
