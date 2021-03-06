--魔導加速
--Magical Boost
--Scripted by Eerie Code
--Prototype, will require either a core update or a script overhaul
function c101003058.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101003058+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101003058.cost)
	e1:SetTarget(c101003058.target)
	e1:SetOperation(c101003058.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101003058.spcon)
	e2:SetTarget(c101003058.sptg)
	e2:SetOperation(c101003058.spop)
	c:RegisterEffect(e2)
end
function c101003058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,2) end
	Duel.DiscardDeck(tp,2,REASON_COST)
end
function c101003058.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1,1)
end
function c101003058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101003058.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003058.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101003058.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1)
end
function c101003058.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsCanAddCounter(0x1,2) and Duel.SelectYesNo(tp,aux.Stringid(101003058,0)) then
			tc:AddCounter(0x1,2)
		else
			tc:AddCounter(0x1,1)
		end
	end
end
function c101003058.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c101003058.spfilter(c,e,tp)
	return (c:IsCode(14553285,45462639,22923081,8034697,43930492,83269557,6061630,10239627,84055227,21051146,55424270,73752131,88901771,46363422,65338781,70791313,73665146,2525268,71413901,5640330,62154416) or (c.spell_counter_permit and c.spell_counter_permit>=2))
		and Duel.IsCanAddCounter(tp,0x1,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101003058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101003058.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101003058.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101003058.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if tc:IsCanAddCounter(0x1,2) and Duel.SelectYesNo(tp,aux.Stringid(101003058,0)) then
			tc:AddCounter(0x1,2)
		else
			tc:AddCounter(0x1,1)
		end
	end
end
