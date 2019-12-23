---
layout: post
category: swing
folder: DisableRightButtonReordering
title: JTableHeaderの列をマウスの右ボタンドラッグで順序変更不可にする
tags: [JTable, JTableHeader, TableColumn, JLayer]
author: aterai
pubdate: 2019-12-23T14:45:20+09:00
description: JLayerを使用してJTableHeaderの列をマウスの右ボタンでドラッグしても順序変更不可に設定します。
image: https://drive.google.com/uc?id=1fETWKkk9g8-SRVPtWT7UmZhoBEue-8rK
comments: true
---
## 概要
`JLayer`を使用して`JTableHeader`の列をマウスの右ボタンでドラッグしても順序変更不可に設定します。

{% download https://drive.google.com/uc?id=1fETWKkk9g8-SRVPtWT7UmZhoBEue-8rK %}

## サンプルコード
<pre class="prettyprint"><code>class DisableRightButtonSwapLayerUI extends LayerUI&lt;JScrollPane&gt; {
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }

  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }

  @Override protected void processMouseMotionEvent(MouseEvent e, JLayer&lt;? extends JScrollPane&gt; l) {
    int id = e.getID();
    Component c = e.getComponent();
    if (c instanceof JTableHeader &amp;&amp;
         id == MouseEvent.MOUSE_DRAGGED &amp;&amp;
         SwingUtilities.isRightMouseButton(e)) {
      e.consume();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、JTableHeaderの列をマウスの右ボタンでドラッグした場合のみ順序変更不可に設定しています。

- 上: `Default`
    - 右ボタンでドラッグ可能なので、`JTableHeader`の外部まで列をドラッグしてポップアップメニューを開くと描画が乱れる場合がある
        - `JPopupMenu#show(...)`メソッドをオーバーライドしてドラッグ中の列をクリア、ヘッダの再描画などを実行して回避する必要がある
    - 列の入れ替えを禁止する場合は`table.getTableHeader().setReorderingAllowed(false);`を設定する
        - [JTableのヘッダ入れ替えを禁止](https://ateraimemo.com/Swing/Reordering.html)
- 下: `Disable right mouse button reordering`
    - `JLayer`を`JTable`を配置した`JScrollPane`に設定
        - `LayerUI#processMouseMotionEvent(...)`メソッドをオーバーライドし、`JTableHeader`上の右ボタンでのドラッグイベントを消費
    - マウスの左、中ボタンでのドラッグは有効
    - マウスの右ボタンをクリックして`JTableHeader`に設定したポップアップメニューを開くことは可能
    - 左ボタンでドラッグ開始、途中で左右両方のボタンを押して右ボタンを後からリリースすると`JTableHeader`の外部でポップアップメニューを開くことが可能なので、`Default`と同様に`JPopupMenu#show(...)`メソッドをオーバーライドしてドラッグ中の列をクリア、ヘッダの再描画などを実行する必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのヘッダ入れ替えを禁止](https://ateraimemo.com/Swing/Reordering.html)
- [JTableHeaderに追加された各TableColumnの表示・非表示を切り替える](https://ateraimemo.com/Swing/AddRemoveTableColumn.html)
- [JComboBoxのドロップダウンリストで右クリックを無効化](https://ateraimemo.com/Swing/DisableRightClick.html)
    - こちらのサンプル同様、`WindowsLookAndFeel`でのみ右ボタンドラッグを無効にしても良いかもしれない

<!-- dummy comment line for breaking list -->

## コメント
