---
layout: post
category: swing
folder: BlockingDialog
title: Modalで透明なJDialogを使って親のJFrameへの入力をブロックする
tags: [JDialog, JFrame]
author: aterai
pubdate: 2015-10-26T04:45:10+09:00
description: Modalで透明なJDialogを表示することで、親のJFrame全体への入力操作をブロックします。
image: https://lh3.googleusercontent.com/-BlvRwXum2Vc/Vi0ubz6y1mI/AAAAAAAAOE4/XKHozK0runE/s800-Ic42/BlockingDialog.png
comments: true
---
## 概要
`Modal`で透明な`JDialog`を表示することで、親の`JFrame`全体への入力操作をブロックします。

{% download https://lh3.googleusercontent.com/-BlvRwXum2Vc/Vi0ubz6y1mI/AAAAAAAAOE4/XKHozK0runE/s800-Ic42/BlockingDialog.png %}

## サンプルコード
<pre class="prettyprint"><code>Window w = SwingUtilities.getWindowAncestor(getRootPane());
JDialog dialog = new JDialog(w, Dialog.ModalityType.DOCUMENT_MODAL); //APPLICATION_MODAL);
dialog.setUndecorated(true);
dialog.setBounds(w.getBounds());
dialog.setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
int color = check.isSelected() ? 0x22_FF_00_00 : 0x01_00_00_00;
dialog.setBackground(new Color(color, true));
(new Task() {
  @Override public void done() {
    if (!isDisplayable()) {
      cancel(true);
      return;
    }
    dialog.setVisible(false);
  }
}).execute();
dialog.setVisible(true);
</code></pre>

## 解説
上記のサンプルでは、以下のような設定を行った`JDialog`を表示することで、親`JFrame`のタイトルバー、閉じる、最大化、最小化ボタンを含めて一定時間入力不可にするテストを行っています。

- モーダル(`Dialog.ModalityType.DOCUMENT_MODAL`)な`JDialog`を作成
- `dialog.setUndecorated(true)`でタイトルバーなどの装飾を非表示に設定
- `JDialog`のカーソルを`Cursor.WAIT_CURSOR`に設定
- `JDialog`の背景色を透明(完全に透明ではない)に設定
- 注: このサンプルには`JDialog`の表示を途中で中断する方法がない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Cursorを砂時計に変更](https://ateraimemo.com/Swing/WaitCursor.html)
- [JLayerで指定したコンポーネントへの入力を禁止](https://ateraimemo.com/Swing/DisableInputLayer.html)

<!-- dummy comment line for breaking list -->

## コメント
