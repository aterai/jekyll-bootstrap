---
layout: post
category: swing
folder: TerminateEdit
title: JTableのセルの編集をコミット
tags: [JTable, Focus, JTableHeader, TableCellEditor]
author: aterai
pubdate: 2007-04-16T12:24:10+09:00
description: セルの編集中、フォーカスが別のコンポーネントに移動した場合、その編集を確定する方法をテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVKX5loMI/AAAAAAAAAnM/hbhZT30xAgc/s800/TerminateEdit.png
comments: true
---
## 概要
セルの編集中、フォーカスが別のコンポーネントに移動した場合、その編集を確定する方法をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVKX5loMI/AAAAAAAAAnM/hbhZT30xAgc/s800/TerminateEdit.png %}

## サンプルコード
<pre class="prettyprint"><code>table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);
</code></pre>

## 解説
デフォルトの`JTable`では、<kbd>Tab</kbd>キーやマウスのクリックなどで同じテーブルの別セルにフォーカスが移動すると編集が確定しますが、別のコンポーネントにフォーカスが移動しても編集は確定しません。

- `terminateEditOnFocusLost`
    - `table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);`を設定
    - 同じフレームを親に持つコンポーネントにフォーカスが移動したとき編集が確定する
    - 別フレームのコンポーネントにフォーカスが移動しても編集中の状態が継続する
    - ヘッダをクリックしたり、列の入れ替え、サイズ変更を実行すると編集はキャンセルされる
- `DefaultCellEditor:focusLost`
    - `DefaultCellEditor`からエディタコンポーネントを取得してこれに`FocusListener`を設定し、セルが編集中なら`table.getCellEditor().stopCellEditing();`を実行
    - 別フレームのコンポーネントにフォーカスが移動したときも、編集が確定する
    - ヘッダをクリック、入れ替え、サイズ変更すると、編集はキャンセルされる
        
        <pre class="prettyprint"><code>DefaultCellEditor dce = (DefaultCellEditor) table.getDefaultEditor(Object.class);
        dce.getComponent().addFocusListener(new FocusAdapter() {
          @Override public void focusLost(FocusEvent e) {
            if (!focusCheck.isSelected()) {
              return;
            }
            if (table.isEditing()) {
              table.getCellEditor().stopCellEditing();
            }
          }
        });
</code></pre>
- `TableHeader:mousePressed`
    - `TableHeader`に`MouseListener`を設定して、セルが編集中なら`table.getCellEditor().stopCellEditing();`

<!-- dummy comment line for breaking list -->
を実行
    - ヘッダをクリックしたとき編集が確定する
    - `JDK 1.7.0`では、このような`MouseListener`を`TableHeader`に設定しなくても、編集が確定するように修正済み
    - [Bug ID: 4330950 Lost newly entered data in the cell when resizing column width](https://bugs.openjdk.java.net/browse/JDK-4330950)
        
        <pre class="prettyprint"><code>table.getTableHeader().addMouseListener(new MouseAdapter() {
          @Override public void mousePressed(MouseEvent e) {
            if (!headerCheck.isSelected()) {
              return;
            }
            if (table.isEditing()) {
              table.getCellEditor().stopCellEditing();
            }
          }
        });
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
親フレームの状態変化でテーブルのヘッダのサイズ変更が発生する場合、ヘッダのリサイズモデルによって、編集中のセルの状態変化が異なります(`JDK 1.7.0`では修正済み: [Bug ID: 4330950 Lost newly entered data in the cell when resizing column width](https://bugs.openjdk.java.net/browse/JDK-4330950))。

- `JTable.AUTO_RESIZE_OFF`
    - 親フレームのリサイズや最大化は編集中のまま
- `JTable.AUTO_RESIZE_ALL_COLUMNS`など
    - 親フレームのリサイズや最大化を行うとヘッダのサイズが変化するため、キャンセル扱い

<!-- dummy comment line for breaking list -->

ヘッダのサイズが変化しない場合は、どちらの設定でも以下のようになります。

- 親フレームの最小化(アイコン化)は編集中のまま
- 親フレームを閉じる場合はキャンセル扱い

<!-- dummy comment line for breaking list -->

親フレームの状態変化に応じて編集の確定を行う場合は、以下のように、`JTable#columnMarginChanged`メソッドなどをオーバーライドしたり、各種リスナーを設定する必要があります。

<pre class="prettyprint"><code>table = new JTable(sorter) {
  @Override public void columnMarginChanged(ChangeEvent e) {
    if (table.isEditing()) {
      table.getCellEditor().stopCellEditing();
    }
    super.columnMarginChanged(e);
  }
};

frame.addWindowListener(new WindowAdapter() {
  @Override public void windowClosing(WindowEvent e) {
    if (table.isEditing()) {
      table.getCellEditor().stopCellEditing();
    }
  }
});

frame.addWindowStateListener(new WindowStateListener() {
  @Override public void windowStateChanged(WindowEvent e) {
    if (frame.getExtendedState() == JFrame.MAXIMIZED_BOTH &amp;&amp; table.isEditing()) {
      table.getCellEditor().stopCellEditing();
    }
  }
});
</code></pre>

## 参考リンク
- [Bug ID: 4330950 Lost newly entered data in the cell when resizing column width](https://bugs.openjdk.java.net/browse/JDK-4330950)
- [jdk7/swing/jdk: changeset 2709:e753db9c4416](http://hg.openjdk.java.net/jdk7/swing/jdk/rev/e753db9c4416)

<!-- dummy comment line for breaking list -->

## コメント
- どわー。助かりましたっ！ -- *shun* 2007-05-31 (木) 19:51:20
    - お役に立てて何よりです(自分もこの辺りよく混乱します)。 -- *aterai* 2007-06-01 (金) 17:30:34
- `columnMarginChanged`、役に立ちました。ありがとうございます。 -- *はじめ* 2008-04-04 (金) 00:35:14
    - どうもです。`JTable#columnMarginChanged`メソッドの`JavaDoc`の説明では、"If a cell is being edited, then editing is stopped and the cell is redrawn."となっているので、`JTable#editingStopped`メソッドを使っている(現在の文字列が新しい値となる)のかなと思ったら、実際は、`JTable#editingCanceled`メソッド(=`JTable#removeEditor`メソッド)でキャンセルしている(編集内容は適用されない)ので、ちょっと混乱してしまいます。 -- *aterai* 2008-04-04 (金) 14:11:01
    - `1.7.0`では、[Bug ID: 4330950 Lost newly entered data in the cell when resizing column width](https://bugs.openjdk.java.net/browse/JDK-4330950) で、修正済みになっているのですが、`getCellEditor().cancelCellEditing()`を使うように変更されているので、編集が消えてしまうのは同じような・・・。 -- *aterai* 2012-02-23 (木) 14:59:49

<!-- dummy comment line for breaking list -->
