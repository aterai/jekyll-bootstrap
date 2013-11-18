---
layout: post
title: JTableのセル編集を文字入力変換中からでも可能にする
category: swing
folder: CompositionEnabled
tags: [JTable, InputContext]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-06-23

## JTableのセル編集を文字入力変換中からでも可能にする
`IME`が直接入力以外で、一時ウィンドウが表示されていても、入力確定でセル編集を開始します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKG6DmuHI/AAAAAAAAAVc/WfOft65kSaQ/s800/CompositionEnabled.png)

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override protected boolean processKeyBinding(
      KeyStroke ks, KeyEvent e, int condition, boolean pressed) {
    boolean retValue = super.processKeyBinding(ks, e, condition, pressed);
    //if(!check.isSelected()) return retValue;
    if(KeyStroke.getKeyStroke('\t').equals(ks) || KeyStroke.getKeyStroke('\n').equals(ks)) {
      System.out.println("tab or enter typed");
      return retValue;
    }
    if(getInputContext().isCompositionEnabled() &amp;&amp; !isEditing() &amp;&amp;
       !pressed &amp;&amp; !ks.isOnKeyRelease()) {
      int selectedRow = getSelectedRow();
      int selectedColumn = getSelectedColumn();
      if(selectedRow!=-1 &amp;&amp; selectedColumn!=-1 &amp;&amp; !editCellAt(selectedRow, selectedColumn)) {
        return retValue;
      }
    }
    return retValue;
  }
};
//table.setSurrendersFocusOnKeystroke(true);
</code></pre>

### 解説
上記のサンプルでは、以下のような設定になっています。

- <kbd>Tab</kbd>や<kbd>Enter</kbd>キーでのセルフォーカス移動では編集開始しない
- `JTable#processKeyBinding`をオーバーライドして、入力モードが確定したら選択セルの編集開始

<!-- dummy comment line for breaking list -->

インプットメソッドが起動中かどうかは、`Component#getInputContext#isCompositionEnabled`メソッドで判断しています。

### 参考リンク
- [Java Input Method Framework テクノロジ](http://docs.oracle.com/javase/jp/6/technotes/guides/imf/index.html)

<!-- dummy comment line for breaking list -->

### コメント
