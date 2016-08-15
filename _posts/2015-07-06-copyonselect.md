---
layout: post
category: swing
folder: CopyOnSelect
title: JTextArea内の文字列がマウス操作で選択されたら自動的にコピーする
tags: [CaretListener, JTextComponent, JTextArea, MouseListener]
author: aterai
pubdate: 2015-07-06T01:50:14+09:00
description: JTextArea内の文字列がマウス操作で選択された場合のイベントを取得するMouseListenerとCaretListenerを設定し、その選択文字列を自動的にクリップボードにコピーする機能を追加します。
image: https://lh3.googleusercontent.com/-HoabV0pfQ0M/VZlcgaYfaeI/AAAAAAAAN8g/BTN-tzs9aUw/s800/CopyOnSelect.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2015/12/copy-on-select-for-jtextarea.html
    lang: en
comments: true
---
## 概要
`JTextArea`内の文字列がマウス操作で選択された場合のイベントを取得する`MouseListener`と`CaretListener`を設定し、その選択文字列を自動的にクリップボードにコピーする機能を追加します。

{% download https://lh3.googleusercontent.com/-HoabV0pfQ0M/VZlcgaYfaeI/AAAAAAAAN8g/BTN-tzs9aUw/s800/CopyOnSelect.png %}

## サンプルコード
<pre class="prettyprint"><code>class CopyOnSelectListener extends MouseAdapter implements CaretListener {
  private boolean dragActive;
  private int dot;
  private int mark;
  @Override public final void caretUpdate(CaretEvent e) {
    if (!dragActive) {
      fire(e.getSource());
    }
  }
  @Override public final void mousePressed(MouseEvent e) {
    dragActive = true;
  }
  @Override public final void mouseReleased(MouseEvent e) {
    dragActive = false;
    fire(e.getSource());
  }
  private void fire(Object c) {
    if (c instanceof JTextComponent) {
      JTextComponent tc = (JTextComponent) c;
      Caret caret = tc.getCaret();
      int d = caret.getDot();
      int m = caret.getMark();
      if (d != m &amp;&amp; (dot != d || mark != m)) {
        String str = tc.getSelectedText();
        if (Objects.nonNull(str)) {
          //StringSelection data = new StringSelection(str);
          //Toolkit tk = Toolkit.getDefaultToolkit();
          //tk.getSystemClipboard().setContents(data, data);
          tc.copy();
        }
      }
      dot = d;
      mark = m;
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、マウス操作を使って文字列を選択する場合のみ、選択文字列を自動的にクリップボードにコピーするリスナーを`JTextArea`に設定しています。

- マウスカーソルのドラッグで文字列選択した場合は、選択終了後にクリップボードにその文字列をコピーする
- <kbd>Shift</kbd>+カーソルキーによる文字列選択は無視する
- <kbd>Shift</kbd>+マウスクリックによる文字列選択は、選択終了後にクリップボードにその文字列をコピーする
- マウスのダブルクリックによる文字列選択は、クリップボードにその操作で選択された文字列をコピーする

<!-- dummy comment line for breaking list -->

## コメント
