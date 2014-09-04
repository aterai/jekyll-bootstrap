---
layout: post
title: JListのセル中に配置したコンポーネント毎にカーソルを変更する
category: swing
folder: CursorOfCellComponent
tags: [JList, Cursor, ListCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-10-21

## 概要
`JList`のセルに配置されているコンポーネントをマウスの座標から検索し、それに設定されたカーソルを`JList`に適用します。

{% download https://lh3.googleusercontent.com/-v3ugRz81Y0Q/UmPxM3SwOYI/AAAAAAAAB4Y/PqZaNMCPgN0/s800/CursorOfCellComponent.png %}

## サンプルコード
<pre class="prettyprint"><code>JList&lt;String&gt; list = new JList&lt;String&gt;(model) {
  private LinkCellRenderer renderer;
  @Override public void updateUI() {
    setForeground(null);
    setBackground(null);
    setSelectionForeground(null);
    setSelectionBackground(null);
    super.updateUI();
    renderer = new LinkCellRenderer();
    setCellRenderer(renderer);
  }
  private int prevIndex = -1;
  @Override protected void processMouseMotionEvent(MouseEvent e) {
    Point pt = e.getPoint();
    int i = locationToIndex(pt);
    String s = ((ListModel&lt;String&gt;)getModel()).getElementAt(i);
    Component c = getCellRenderer().getListCellRendererComponent(
        this, s, i, false, false);
    Rectangle r = getCellBounds(i, i);
    c.setBounds(r);
    if(prevIndex!=i) {
      c.doLayout();
    }
    prevIndex = i;
    pt.translate(-r.x, -r.y);
    Component cmp = SwingUtilities.getDeepestComponentAt(c, pt.x, pt.y);
    if(cmp != null) {
      setCursor(cmp.getCursor());
    }else{
      setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、以下の手順でイベントを取得しないセルレンダラー中のコンポーネントに応じたカーソルの変更を行っています。

- `JList`上をマウスカーソルを移動した時に、カーソルのある行を取得
- セルレンダラーに行番号や文字列などの値を渡して描画用のコンポーネントを取得
- 描画用コンポーネントの位置とサイズを`JList#getCellBounds()`で取得したセル領域に変更
    - `Component#setBounds(...)`で描画用コンポーネントの位置とサイズを変更してもその子コンポーネントのレイアウトは更新されない
- `Component#doLayout()`で、レイアウトを更新
    - このサンプルで使用している`FlowLayout`では、`JLabel`に設定する文字列の長さで後続のコンポーネントの位置が変化するので、`Component#doLayout()`が必要
    - ただし、同じ行の場合は描画用コンポーネントも前回と同じはずなのでレイアウトを更新する必要はない
    - [JListのセル内にJButtonを配置する](http://terai.xrea.jp/Swing/ButtonsInListCell.html)などのように、すべての行のレイアウトが同じ(内容に応じて変化しない)場合も同様に更新する必要はない
- JList基準のカーソル座標を描画用コンポーネント基準に変更
- `SwingUtilities.getDeepestComponentAt(...);`で描画用コンポーネントから変更した座標の下にある子コンポーネントを取得
- 取得した子コンポーネントのカーソルを`JList`のカーソルとして設定

<!-- dummy comment line for breaking list -->

## コメント
