---
layout: post
title: JTableでキー入力によるセル編集自動開始を一部禁止する
category: swing
folder: FunctionKeyStartEditing
tags: [JTable, ActionMap, InputMap]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-03-07

## JTableでキー入力によるセル編集自動開始を一部禁止する
`JTable`のセル編集自動開始をファンクションキーの場合だけ無効にします。[Swing - JTable starts editing when F3 is pressed - howto disable?](https://forums.oracle.com/thread/1350192)を参考にしています。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TXR_CO_Z9UI/AAAAAAAAA3I/7_3ml86ybo8/s800/FunctionKeyStartEditing.png %}

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  //Swing - JTable starts editing when F3 is pressed - howto disable?
  //https://forums.oracle.com/thread/1350192
  @Override public boolean editCellAt(int row, int column, EventObject e) {
    if(e instanceof KeyEvent) {
      int c = ((KeyEvent)e).getKeyCode();
      if(KeyEvent.VK_F1&lt;=c &amp;&amp; c&lt;=KeyEvent.VK_F21) {
        return false;
      }
    }
    return super.editCellAt(row, column, e);
  }
}
</code></pre>

### 解説
- `ignore: F1,F4-F7,F9-`
    - チェックボックスをチェックしている場合、ファンクションキー(<kbd>Shift</kbd>, <kbd>Ctrl+Function</kbd>キーも含む)を押しても、セルの編集が開始されないように`JTable#editCellAt(...)`メソッドをオーバーライド

<!-- dummy comment line for breaking list -->

- `table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);`
    - キー入力(<kbd>F2</kbd>は除く)によるセルの編集開始を禁止
    - [JTableでキー入力によるセル編集開始を禁止する](http://terai.xrea.jp/Swing/PreventStartCellEditing.html)

<!-- dummy comment line for breaking list -->

- - - -
上記のサンプルには、`InputMap`、`ActionMap`に<kbd>F3</kbd>キーで`beep`が鳴るようにキーストロークとアクションを追加しています。このキーストロークは`JTable#editCellAt`メソッドでのキー入力チェックとは別に実行されるので、デフォルトの<kbd>F2</kbd>キーでの`startEditing`、<kbd>F8</kbd>キーでの`focusHeader`は、`JTable#editCellAt(...)`の戻り値とは関係なく有効になっています。

- `JTable#processKeyBinding(...)`をオーバーライドしてキー入力自体を弾くと、`InputMap`に追加したキーストロークも除かれるので、これらのアクションも実行されない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - JTable starts editing when F3 is pressed - howto disable?](https://forums.oracle.com/thread/1350192)
- [JTableでキー入力によるセル編集開始を禁止する](http://terai.xrea.jp/Swing/PreventStartCellEditing.html)

<!-- dummy comment line for breaking list -->

### コメント
