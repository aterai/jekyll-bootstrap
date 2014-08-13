---
layout: post
title: JComboBoxのアイテム文字列を左側からクリップ
category: swing
folder: LeftClippedComboBox
tags: [JComboBox, ListCellRenderer, ArrowButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-06-18

## JComboBoxのアイテム文字列を左側からクリップ
`JComboBox`のアイテム文字列がコンポーネントより長い場合、これを左側からクリップします。


{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPEaiR2iI/AAAAAAAAAdY/E5fxUtKW0sM/s800/LeftClippedComboBox.png %}

### サンプルコード
<pre class="prettyprint"><code>final JButton arrowButton = getArrowButton(combo02);
combo02.setRenderer(new DefaultListCellRenderer() {
  @Override public Component getListCellRendererComponent(
        JList list, Object value, int index,
        boolean isSelected, boolean cellHasFocus) {
    super.getListCellRendererComponent(list,value,index,isSelected,cellHasFocus);
    int itb=0, ilr=0;
    Insets insets = getInsets();
    itb+=insets.top+insets.bottom; ilr+=insets.left+insets.right;
    insets = combo02.getInsets();
    itb+=insets.top+insets.bottom; ilr+=insets.left+insets.right;
    int availableWidth = combo02.getWidth()-ilr;
    if(index&lt;0) {
      //@see BasicComboBoxUI#rectangleForCurrentValue
      int buttonSize = combo02.getHeight()-itb;
      if(arrowButton!=null) {
        buttonSize = arrowButton.getWidth();
      }
      availableWidth -= buttonSize;
      JTextField tf = (JTextField)combo02.getEditor().getEditorComponent();
      insets = tf.getMargin();
      availableWidth -= (insets.left + insets.right);
    }
    String cellText = (value!=null)?value.toString():"";
    //&lt;blockquote cite="http://tips4java.wordpress.com/2008/11/12/left-dot-renderer/"&gt;
    //@title Left Dot Renderer
    //@auther Rob Camick
    FontMetrics fm = getFontMetrics(getFont());
    if(fm.stringWidth(cellText)&gt;availableWidth) {
      String dots = "...";
      int textWidth = fm.stringWidth(dots);
      int nChars = cellText.length() - 1;
      while(nChars&gt;0) {
        textWidth += fm.charWidth(cellText.charAt(nChars));
        if(textWidth &gt; availableWidth) break;
        nChars--;
      }
      setText(dots+cellText.substring(nChars+1));
    }
    //&lt;/blockquote&gt;
    return this;
  }
});
</code></pre>

### 解説
標準の`JComboBox`では、長い文字列は右側をクリップするので、上記のサンプルでは左側を切り取り、`...`で置き換えるようにセルレンダラーを変更しています。

例えば、コンボボックスのセルよりファイル名が長くても、拡張子が表示できるようにしたいといった場合に使用します。

エディタ部分(`index<0`の場合)を描画するときは、矢印ボタンの幅を考慮する必要があります。

`LookAndFeel`によって余白などのサイズが微妙に異なる場合がある？ため、うまく表示されないことがあります。

### 参考リンク
- [Swing - JTable - right align in cell even if the text is wider than the cell](https://forums.oracle.com/thread/1389543)
    - camickr さんの投稿(2005/06/10 5:52)した`JTable`でのサンプルを参考にしています。
- [Left Dot Renderer « Java Tips Weblog](http://tips4java.wordpress.com/2008/11/12/left-dot-renderer/)

<!-- dummy comment line for breaking list -->

### コメント
- 参考リンク、スクリーンショット更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-11-13 (木) 14:26:39

<!-- dummy comment line for breaking list -->

