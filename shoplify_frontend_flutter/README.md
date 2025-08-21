# shoplify

check todos

make app responsive



TOD0: fix 400 bad auth where a deactivated user accounts tries to refresh the token and ends up in a loop
clear cache and bloc data on log out

fix login 401 auth on login retry

adb.exe reverse tcp:8000 tcp:8000

TODO: check blocs

check null


📦 2. Order Details Page (After Checkout)

Now the user sees the new order summary.

Show:

Order ID

Placed At

Order Status = New

Payment Status = Unpaid

Items list (with quantity & price)

Total Price

👉 Next step is Payment.

Show Make Payment button.

💳 3. Payment Flow

When user taps Make Payment:

Call /orders/{id}/make_payment/ (backend prepares payment session → e.g. Paystack/Flutterwave/Stripe link).

Frontend redirects user to payment gateway UI (browser overlay/webview/SDK).

After payment:

Either redirect back to app with payment reference, OR

Webhook notifies backend and frontend polls /orders/{id}/ for updated payment_status.

UI now updates:

Payment Status = Paid

Order Status = Pending (waiting for admin to fulfill).


📦 4. Orders List Page (History)

User can view all their orders.
Each card shows:

Order ID, Date

Order Status (Pending, Completed, Failed)

Payment Status (Paid/Unpaid)

Total

🚚 5. Next After Payment

Once admin/store processes order:

order_status changes → Completed (delivered) or Failed (canceled).

Frontend order list & details update automatically.
